###
# Function to parse header and put into fields in dataframe
###
parseHeader = function(header) {
  
  # split out fields by |
  fields = strsplit(header,"|", fixed = T)
  # break out of the list
  fields = (unlist(fields))
  
  # write individual fields to new variables
  id = gsub(">","",fields[1]) # remove >
  id = gsub(" ","",id) # remove spaces
  virus = fields[2]
  strain = fields[3]
  country = fields[4]
  date = fields[5]
  
  # write values to new data frame
  fields_df = data.frame(id,virus,strain,country,date)
  colnames(fields_df) = c("id","virus","strain","country","date")
  
  # return df with header and columns
  return(fields_df)
}

###
# function nullCheck
###
isNull = function(string) {
  # default to false
  is_null = FALSE
  # if empty, na, or null, then return true
  if (string == "" || is.na(string) || is.null(string)) {
    is_null = TRUE
  }
  # return boolean
  return(is_null)
}

### 
# Function to only keep sequences that don't have missing values
###
getKeepIDs = function(input_file) {
  
  # instantiate empty vector to store the IDs
  selected_ids = NULL
  
  # read individual lines from .fasta file
  seq_lines = readLines(input_file)
  
  # loop over each line in .fasta file
  for (i in 1:length(seq_lines)) {
    # if a header line
    if (startsWith(seq_lines[i],">")) {
      # parse header
      header = parseHeader(seq_lines[i])
      # if header is missing strain or date
      if (isNull(header$strain) || isNull(header$date)) {
        next # skip; don't add id
      } else {
        selected_ids = append(selected_ids, header$id) # else keep the id
      }
    } 
  }
  
  # return all the sequence ids we want to keep
  return(selected_ids)
}

### 
# Function to subset a .fasta file based on sequence IDs
###
subsetFasta <- function(input_file, output_file) {
  
  # get all of the ids that don't have missing values
  selected_ids = getKeepIDs(input_file)
  print(head(selected_ids))
  # Read the .fasta file
  fasta_data <- readLines(input_file)
  
  # Open the output file for writing
  output_con <- file(output_file, "w")
  
  # Initialize variables
  keep_seq <- FALSE
  
  # loop through each line in fasta file
  for (i in 1:length(fasta_data)) {
    # if it's a header line
    if (startsWith(fasta_data[i],">")) {
      # get sequence id from header
      seq_id = parseHeader(fasta_data[i])$id
      # If this header is in the Keep IDs, set write_seq to TRUE
      keep_seq <- seq_id %in% selected_ids
      # if it's a Keep ID 
      if (keep_seq) {
        # Write the header to the output file
        writeLines(fasta_data[i], output_con)
      }
    } else {
      # if it's not a header line, BUT write_seq is still TRUE, then write the line to the output
      if (keep_seq) {
        # Write the sequence to the output file
        writeLines(fasta_data[i], output_con)
      }
    }
  }
  
  # Close the output file
  close(output_con)
}

# subset sequences with only the good ids
subsetFasta("~data/sequences_all.fasta", "~data/sequences_all_subset.fasta")
