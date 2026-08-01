import csv
import os

file_path = '/Users/irfanrahmat/development/fyp_project/diy_umrah_planner_app/assets/data/umrah_flights_data.csv'
temp_file = file_path + '.tmp'

# Define LCC codes
lcc_codes = ['AK', 'OD']

try:
    with open(file_path, mode='r', newline='', encoding='utf-8') as infile, \
         open(temp_file, mode='w', newline='', encoding='utf-8') as outfile:
        
        reader = csv.DictReader(infile)
        fieldnames = reader.fieldnames
        
        # Add new column if not exists
        if 'service_type' not in fieldnames:
            fieldnames.append('service_type')
            
        writer = csv.DictWriter(outfile, fieldnames=fieldnames)
        writer.writeheader()
        
        for row in reader:
            airline_code = row.get('airline', '').strip().upper()
            
            # Determine Service Type
            if airline_code in lcc_codes:
                row['service_type'] = 'LCC'
            else:
                row['service_type'] = 'non-LCC'
                
            writer.writerow(row)
            
    # Replace original file
    os.replace(temp_file, file_path)
    print("CSV updated successfully with service_type column.")

except Exception as e:
    print(f"Error updating CSV: {e}")
