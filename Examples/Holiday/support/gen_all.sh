#!/bin/bash
# data preprocessing for Kal Holidays example
# Keith Lazuka 2011-01-22
# If you want to add new holidays, add them to holidays.txt in the existing format.
# Please make sure that the country name has a corresponding flag image.

./holidays_preprocessor.py json < holidays.txt > holidays.json
./holidays_preprocessor.py sqlite < holidays.txt > holidays_setup.sql
rm ../holidays.db
sqlite3 -init holidays_setup.sql ../holidays.db
