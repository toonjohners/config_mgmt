README:

Install & Running:

1. Run the INSTALLER Script
2. Open the RUNCHECK Script and change the INST_HOME variable to the installation directory
3. Run the RUNCHECK script to make sure the script runs ok.
4. Create a cron to run the RUNCHECK script.

View the report:
1. Once the RUNCHECK script has been run, it creates a report within the .config_mgmt/system/files/html/. directory.
2. You can copy this directory to your local desktop to view the report.
3. Open the index.html file to view.

Standalone Audit.
1. Navigate to .config_mgmt_sol/standalone_audit.
2. Run collect.sh
3. Copy this file to an existing installation
4. Run extract.sh
5. Run REPORT script (OPEN Script and change the INST_HOME variable to the installation directory)
6. View the report as previously stated.
