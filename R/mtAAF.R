#' mtAAF function
#'
#' Derivation of alternative allele fraction
#'
#' @param allele Allele dataset, numeric matrix
#' @param freq Frequency dataset, numeric matrix
#'
#' @return AAF, numeric matrix with dimensions of n subjects x 16569 SNPs
#' @export
#' @examples
#'
#' #Read input data
#' allele_file <- "/restricted/projectnb/mtdna-alcohol/Sun_Xianbang/ARIC/allele/allele.csv"
#' freq_file <- "/restricted/projectnb/mtdna-alcohol/Sun_Xianbang/ARIC/freq/freq.csv"
#'
#' #head <- scan( file = allele_file, sep = ",", character(), nlines = 1, quiet = TRUE)
#' #allele   <- matrix( scan( file = allele_file,
#' #                          sep = ",", character() ),
#' #                    ncol = length( head ), byrow = TRUE)
#' #freq     <- matrix( scan( file = freq_file,
#' #                          sep = ",", character() ),
#' #                    ncol = length( head ), byrow = TRUE)
#'
#' #mtPAA (coverage, allele, freq)
mtAAF <- function( allele, freq ){


  # if((sum(dim(coverage) != dim(allele) ) > 0) | (sum(dim(coverage) != dim(freq))>0)){
  #   stop("the coverage, allele and frequency should have same dimension")
  # }

  # order the allele, freq and coverage datasets by ID
  allele <- allele[order(allele[,1]), ]
  freq <- freq[order(freq[,1]), ]

  # record the IDs in the vector of subjectID, and remove the ID column from the original dataset
  subjectID <- allele[,1]
  allele <- allele[,-1]
  freq   <- freq[,-1]

  # transpose the allele, freq and coverage datasets, so each column vector represents the sequence of a subject
  allele <- t(allele)
  freq <- t(freq)


  AAF3.m <- array(0, dim(allele) )
  complex.allele <- which(allele != .mtRef)
  AAF3.m [complex.allele] <- 1

  complex.allele <- complex.allele[ grepl( "/",  allele[complex.allele])]
  complex.all2 <- strsplit( allele[complex.allele], split="/" )

  complex.freqsplit <- strsplit( freq[complex.allele], split="/")
  complex.freqsplit <- lapply( complex.freqsplit, as.numeric)

  complex.ref <- .mtRef[ (complex.allele -1) %% length(.mtRef) + 1]
  AAF3.m[complex.allele] <- mapply(function(x, y, z){ pos <- which(x == z); if(length(pos) > 0) max(y[-pos]) else max(y)  } ,
                                   x= complex.all2, y = complex.freqsplit, z = complex.ref)
  AAF3.m <- t(AAF3.m)
  rownames(AAF3.m) <- subjectID
  AAF3.m

}