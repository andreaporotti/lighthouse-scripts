#! /usr/bin/bash

# File containing the list of url to scan
urlList="lh_list.txt"

# Setup Lighthouse commands
desktopCommand="lighthouse {{url}} --preset=desktop --form-factor=desktop --screenEmulation.mobile=false --screenEmulation.width=1440 --screenEmulation.height=800 --screenEmulation.deviceScaleFactor=1.75 --chrome-flags=""--headless"" --quiet --output-path=./{{reportName}}.html"
mobileCommand="lighthouse {{url}} --form-factor=mobile --screenEmulation.mobile=true --screenEmulation.width=360 --screenEmulation.height=800 --screenEmulation.deviceScaleFactor=1.75 --chrome-flags=""--headless"" --quiet --output-path=./{{reportName}}.html"

# Parse url list
while IFS= read -r url
do
  # Skip empty rows
  if [ "$url" != "" ]
  then
    # Skip rows starting with '#' (comments)
    if [[ $url != \#* ]]
    then
      # Sanitize the url so it can be used in the report file name
      sanitizedUrl=$url

      # -- remove trailing slashes
      sanitizedUrl=$(echo "$sanitizedUrl" | sed 's:/*$::')

      # -- remove "http://"
      sanitizedUrl=$(echo "${sanitizedUrl//http:\/\//}")

      # -- remove "https://"
      sanitizedUrl=$(echo "${sanitizedUrl//https:\/\//}")

      # -- remove "www."
      sanitizedUrl=$(echo "${sanitizedUrl//www./}")

      # -- replace "."
      sanitizedUrl=$(echo "${sanitizedUrl//./_}")

      # -- replace "."
      sanitizedUrl=$(echo "${sanitizedUrl//\//--}")

      # -- replace "?"
      sanitizedUrl=$(echo "${sanitizedUrl//\?/-}")

      # -- replace "&"
      sanitizedUrl=$(echo "${sanitizedUrl//\&/-}")

      # Run desktop scan
      echo "Scanning url: $url (DESKTOP)"

      # -- generate report file name
      now=$(date +"%Y-%m-%d_%H-%M-%S")
      reportName="${sanitizedUrl}_DESKTOP_${now}"
      
      # -- generate command
      command=$desktopCommand
      command=$(echo "${command//'{{url}}'/$url}")
      command=$(echo "${command//'{{reportName}}'/$reportName}")

      # -- run command
      $command

      # Run mobile scan
      echo "Scanning url: $url (MOBILE)"

      # -- generate report file name
      now=$(date +"%Y-%m-%d_%H-%M-%S")
      reportName="${sanitizedUrl}_MOBILE_${now}"
      
      # -- generate command
      command=$mobileCommand
      command=$(echo "${command//'{{url}}'/$url}")
      command=$(echo "${command//'{{reportName}}'/$reportName}")

      # -- run command
      $command
    fi
  fi
done < $urlList