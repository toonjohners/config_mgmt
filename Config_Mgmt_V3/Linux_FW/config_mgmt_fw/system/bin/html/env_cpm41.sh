export FW_CONSOLE_PORT_ON=0
export FUSIONWORKS_PROD=/fwdata/cpm41/prod
export FUSIONWORKS_HOME=/fwdata/cpm41/home
export JAVA_HOME=/usr/jre1.6.0_27
export ORACLE_HOME=/oracle/app
#export ORBACUS_HOME=/usr/local64
export PATH=$JAVA_HOME/bin:$ORACLE_HOME/bin:$PATH:$FUSIONWORKS_PROD/bin:/usr/lib/:/lib/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$FUSIONWORKS_PROD/lib:$ORACLE_HOME/lib
