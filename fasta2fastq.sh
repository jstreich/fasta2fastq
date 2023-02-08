#########################################################################################################
############################## Example of Paired end Reads in Fastq Format ##############################
#########################################################################################################


#########################################
##### Description of what is needed #####
#########################################

# R1.fastq :
# @M00991:61:000000000-A7EML:1:1101:14011:1001 1:N:0:28
# NGCTCCTAGGTCGGCATGATGGGGGAAGGAGAGCATGGGAAGAAATGAGAGAGTAGCAA
# +
# #8BCCGGGGGFEFECFGGGGGGGGG@;FFGGGEG@FF<EE<@FFC,CEGCCGGFF<FGF

# R2.fastq :
# @M00991:61:000000000-A7EML:1:1101:14011:1001 2:N:0:28
# TTGCTACTCTCTCATTTCTTCCCATGCCTTCCTTCCCCCATCATGCCGACCTAGGAGCC
# +
# CCCCC,;FF,EA9CEE<6CFAFGGGD@,,6CC<FA@FG:FF8@F9EE7@FGCFGFFFFG


##################################################################
##### Actual output should look like this per each iteration #####
##################################################################

# @fasta2fastq:0:0:0:0:{i} 1:N:0:{i}
# NGCTCCTAGGTCGGCATGATGGGGGAAGGAGAGCATGGGAAGAAATGAGAGAGTAGCAA
# +
# IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
# @fasta2fastq:0:0:0:0:{i} 1:N:0:{i}
# TTGCTACTCTCTCATTTCTTCCCATGCCTTCCTTCCCCCATCATGCCGACCTAGGAGCC
# +
# IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII




#########################################################################################################
############################ Steps and code to create Fastq from Fasta ##################################
#########################################################################################################

########## Pre steps: ##########

### Remove any extra lines in fasta file so it’s only one long line of characters.
sed -z 's/\n//g;s/$/\n/' [ref.fasta] > [newRef.fasta]


##### Manual steps:

### Create plus sign file, probably nano is the simplest, just a file with a single plus symbol.

### Create file with quality scores of ‘I’ at length 150 all in the first line

### Create an emptry R1.fastq and R2.fastq files to prime concatenation in loop

### Find length of characters that will be used for extraction loop
awk '{ print length }' ref.fasta
3980200/300 = 13,267.3334
13,267 is the total number of complete loops we can do in this reference

########## Actual Commands in Order ##########
for i in {1..13267}; 
do

##### Step 1: Copy out 300bp at a time to a file, split each end into R1 and R2 with names as required in above example
## Take a line and split into two lines
head -c 300 ref_DSM7_singleline.fasta | sed 's/.\{150\}/&\n/g' > 1st300toTwoLines.txt


##### Step 2: Get specific line of 1st300toTwoLines.txt as reverse read
sed -n '2p' 1st300toTwoLines.txt > tempR2.txt


##### Step 3: Get 1st line of 1st300toTwoLines.txt as tempR1.txt
head -1 1st300toTwoLines.txt > tempR1.txt


##### Create file with counts, thus shows the position in the reference a read was created from 
echo @fasta2fastq:0:0:0:0:$i 1:N:0:$i | cat > header1.txt ; echo @fasta2fastq:0:0:0:0:$i 2:N:0:$i | cat > header2.txt; done


##### Cat together header file, plus
cat header1.txt tempR1.txt plus.txt qualityscores.txt > compR1.txt
cat header2.txt tempR2.txt plus.txt qualityscores.txt > compR2.txt


##### Cut first 300 characters out of single line fasta that were just used to create reads from
cut -c 300- original.fasta > temp.fasta
mv temp.fasta original.fasta

done


########## Actual Loop ##########

########## Actual Commands in Order ##########
for i in {1..13267}; 
  do head -c 300 ref_DSM7_singleline.fasta | sed 's/.\{150\}/&\n/g' > 1st300toTwoLines.txt;
  sed -n '2p' 1st300toTwoLines.txt > tempR2.txt;
  head -1 1st300toTwoLines.txt > tempR1.txt;
  rm 1st300toTwoLines.txt;
  echo @fasta2fastq:0:0:0:0:$i 1:N:0:$i | cat > header1.txt;
  echo @fasta2fastq:0:0:0:0:$i 2:N:0:$i | cat > header2.txt;
  cat header1.txt tempR1.txt plus.txt qualityscores.txt > compR1.txt;
  cat header2.txt tempR2.txt plus.txt qualityscores.txt > compR2.txt;
  cut -c 300- ref_DSM7_singleline.fasta > temp.fasta;
  mv temp.fasta ref_DSM7_singleline.fasta;
  cat > compR1.txt R1.fastq > R1.temp;
  cat > compR2.txt R2.fastq > R2.temp;
  mv R1.temp R1.fastq;
  mv R2.temp R2.fastq;
  rm compR1.txt;
  rm compR2.txt;
  rm header1.txt;
  rm header2.txt;
  rm temp.fasta;
done


##### Create duplicate files that are concatenated to simulate coverage
for i in {1..20}; do cp R1.fastq R1_${i}_copy.fastq ; cp R2.fastq R2_${i}_copy.fastq; done

cat R1* > R1_sim_DSM7_velensenzis.fastq
cat R2* > R2_sim_DSM7_velensenzis.fastq





#########################################################################################################
####################################### Citations #######################################################
#########################################################################################################

##### Get first n characters from line
https://unix.stackexchange.com/questions/346367/getting-first-n-characters-from-a-file

##### Seperate string into two lines based on n characters into string
https://unix.stackexchange.com/questions/5980/how-do-i-insert-a-space-every-four-characters-in-a-long-line

##### Insert character set every nth line, for plus sign and quality scores
https://www.unix.com/shell-programming-and-scripting/256297-insert-string-every-n-lines-resetting-line-counter-desired-string.html

##### Get specific line of file and output to new file, used to put paired end reads in unique files
https://www.unix.com/unix-for-dummies-questions-and-answers/768-extract-specific-lines-file.html
