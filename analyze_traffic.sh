#!/usr/bin/bash



############################################                      script info                 ###############################################

# script purpose : Bash Script to Analyze Network Traffic

# Input :
# Path to the Wireshark pcap file

# output :
 

 # echo "----- Network Traffic Analysis Report -----"

  # Provide summary information based on your analysis

  # Hints: Total packets, protocols, top source, and destination IP addresses.

############  echo "1. Total Packets: [your_total_packets]"

############  echo "2. Protocols:"

#   echo "  - HTTP: [your_http_packets] packets"

#   echo "  - HTTPS/TLS: [your_https_packets] packets"

#   echo ""

############ echo "3. Top 5 Source IP Addresses:"

  # Provide the top source IP addresses

#   echo "[your_top_source_ips]"

#   echo ""

############ echo "4. Top 5 Destination IP Addresses:"

  # Provide the top destination IP addresses

#   echo "[your_top_dest_ips]"

#   echo ""

#############  echo "----- End of Report -----"


 


############################################  function declration & glopal varibles & sourcing files   ##############################################

source ./analyze_trafic_confg

declare FILEPATH=$1       # glopal varibe to save file path


# function to print strings 
function print(){
  
  echo "$1"
}
 
#create a Bash function that wraps tshark and can take any number of arguments
function analysis_tool() {
    tshark -l "${@}" | while read line; do
        # Process each line from tshark output
        echo "$line"
    done
}



###########################################################          Total Packets Function                    ############################################################### 

function Total_Packets(){

  declare -i PACKETS=0
  PACKETS=$(analysis_tool -r "${1}" | wc -l) # count total packets
  printf "\n"
  print "1. Total Packets: ${PACKETS}"
  printf "\n"
}


###########################################################          Protocols Function                        ############################################################### 

function Protocols (){
   
 print "2.Protocols "  
 printf "\n"
for word in $FILTERD_PROTOCOLS; do
      print "- ${word} Packets: $(analysis_tool -r "${1}" -Y "${word}" | wc -l) " # Filters for packets that have the http protocol in their header
done
printf "\n"

}

###########################################################        Top 5 Source IP Addresses Function        ############################################################### 

function Source_Address(){
    
  echo "3.Top 5 Source IP Addresses: "
  printf "\n"
  # Select source ip fields to output , Display number of occurrences of each line, sorted by the most frequent,Select source ip fields to output , Display number of occurrences of each line, sorted by the most frequent,Output the first 5 lines.
  analysis_tool -r "${FILEPATH}" -T fields -e ip.src | sort | uniq -c | sort -nr | head --lines 5 | awk '{print "- "$2" :"$1" packets "}'  
   printf "\n"
}


###########################################################        Top 5 Destination IP Addresses Function   ############################################################### 

function Destination_Address(){
     
    echo "4.Top 5 Destination IP Addresses: "
    printf "\n"
    #Select source ip fields to output , Display number of occurrences of each line, sorted by the most frequent,Select destination ip fields to output , Display number of occurrences of each line, sorted by the most frequent ,Output the first 5 lines.
    analysis_tool -r "${FILEPATH}" -T fields -e ip.dst | sort | uniq -c | sort -nr | head --lines 5 | awk '{print "- "$2" :"$1" packets "}' 
    printf "\n"
}




function analyze_traffic(){

  if [ ! -e "${FILEPATH}" ]; then
    echo "File not exists " > "${LOG_FILE}" #check if file exist or not
    exit 1 #close program
fi

  Total_Packets "${FILEPATH}"
  Protocols "${FILEPATH}"
  Source_Address
  Destination_Address

}



###########################################################        main function           ############################################################### 

function main(){
  analyze_traffic "${FILEPATH}"
}


###########################################################      calling main            ##################################################################### 

main 