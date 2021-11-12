# Helper functions
infobanner()
{
  echo "+------------------------------------------+"
  printf "| %-40s |\n" "`date`"
  echo "|                                          |"
  printf "|`tput bold` %-40s `tput sgr0`|\n" "$@"
  echo "+------------------------------------------+"
}

titlebanner()
{
  echo "\n"
  echo "+------------------------------------------------------------------------------------------------+"
  echo "  ########:::'#######:::'#######::'########::'######::'########:'########:::::'###::::'########::
  ##.... ##:'##.... ##:'##.... ##:... ##..::'##... ##:... ##..:: ##.... ##:::'## ##::: ##.... ##:
  ##:::: ##: ##:::: ##: ##:::: ##:::: ##:::: ##:::..::::: ##:::: ##:::: ##::'##:. ##:: ##:::: ##:
  ########:: ##:::: ##: ##:::: ##:::: ##::::. ######::::: ##:::: ########::'##:::. ##: ########::
  ##.... ##: ##:::: ##: ##:::: ##:::: ##:::::..... ##:::: ##:::: ##.. ##::: #########: ##.....:::
  ##:::: ##: ##:::: ##: ##:::: ##:::: ##::::'##::: ##:::: ##:::: ##::. ##:: ##.... ##: ##::::::::
  ########::. #######::. #######::::: ##::::. ######::::: ##:::: ##:::. ##: ##:::: ##: ##::::::::
 ........::::.......::::.......::::::..::::::......::::::..:::::..:::::..::..:::::..::..:::::::::"
 printf "+---Created By `tput bold`Oliver Haney`tput sgr0`----------------------------------------------------------------------+"
 echo "\n\n"
}

titlebanner
sleep 2s


# Install homebrew
if ! command -v brew &> /dev/null; then
  # The package is not installed
  infobanner 'Installing Homebrew'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  infobanner 'Homebrew installed successfully'
else
  # The package is installed
  infobanner 'Homebrew already installed'
  git -C /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core fetch --unshallow
  git -C /usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask fetch --unshallow
  brew update
  brew upgrade
  infobanner 'Homebrew up to date!'
  infobanner 'Running Hombrew doctor'
  brew doctor --list-checks  
fi

infobanner "Installing dev packages..."

# Install dev packages
brew tap AdoptOpenJDK/openjdk
brew install --cask adoptopenjdk8
brew install --cask adoptopenjdk11
brew install python
brew install npm
brew install gradle
brew install mysql@5.7

COUNTER=0
PROCESSED_ALIASES=""
infobanner 'Bootstrapping machine!'

printf "\n`tput bold`Aliases registered:\n"  
while IFS="" read -r line || [ -n "$line" ]
do
  if [ $COUNTER -eq 22 ]; then
    break
  else
    echo $line | awk -F. '{print substr($0,7)}'
  fi
  (( COUNTER=$COUNTER+1 ))
done < .bashrc

echo $PROCESSED_ALIASES

cp .bashrc ~/.bashrc
(cd /tmp && ([[ -d sexy-bash-prompt ]] || git clone --depth 1 --config core.autocrlf=false https://github.com/twolfson/sexy-bash-prompt) && cd sexy-bash-prompt && make install) && source ~/.bashrc

infobanner '.bashrc initialized'
infobanner 'Bootstrapping completed!'

