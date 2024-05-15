import os
import sys
import pandas as pd
import requests
from bs4 import BeautifulSoup
import re
import ssl
from pathlib import Path

def create_data_dictionary():
    """
    1. Set CONSTANTS for project page
    2. Get links to data dictionary csv files
    3. Create list of data dictionary urls
    4. Concat all data dictionary files into a dataframe
    @chrisgebert
    """
    AHRQ_BASE_URL = 'https://www.ahrq.gov'
    SYH_DR_URL = 'https://www.ahrq.gov/data/innovations/syh-dr.html'

    # Get all links to Data Dictionary CSV files
    response = requests.get(SYH_DR_URL)
    soup = BeautifulSoup(response.text, 'html.parser')

    # Create list of data dictionary URLs (i.e., where attribute is like "Variables")
    data_dictionary_urls = []
    for url in soup.find_all("a", string=re.compile("Variables")):
        csv_url = AHRQ_BASE_URL + url.attrs.get("href")
        data_dictionary_urls.append(csv_url)

    # Concat all data dictionaries into a dataframe and write to a file
    ssl._create_default_https_context = ssl._create_unverified_context
    data_dictionary_df = pd.concat((pd.read_csv(url) for url in data_dictionary_urls), ignore_index=True)
    data_dictionary_df = data_dictionary_df[data_dictionary_df["Variable Name"].notnull()]
    data_dictionary_df.to_csv("./data_processing/seeds/SyH-DR_data_dictionary.csv", index=False)

    return data_dictionary_df[["Variable Label", "Variable Name", "Variable Type", "Variable Format", "Variable Length"]]

def map_variable_type_to_sql(variable_name, variable_type, variable_length, variable_format):
    if "_ID" in variable_name:
        return "UBIGINT"
    elif "LOS" in variable_name:
        return "UINTEGER"
    elif "_DT" in variable_name or "_DATE" in variable_name:
        return "DATE"
    elif "DOLLAR" in variable_format:
        return "FLOAT"
    elif variable_type == "NUM":
        return f"NUMERIC"
    elif variable_type == "CHAR":
        return f"VARCHAR"
    else:
        return "TEXT"

def process_csv_files(data_dictionary_df, csv_folder):
    csv_folder = Path(csv_folder)

    # Define the CSV file names
    csv_files = [f for f in csv_folder.glob('*.CSV')]

    # Process each CSV file
    for csv_file in csv_files:
        if not csv_file.exists():
            print(f"File not found: {csv_file}")
            continue

        try:
            df = pd.read_csv(csv_file, nrows=1)
        except Exception as e:
            print(f"Error reading CSV file {csv_file}: {e}")
            continue

        column_names = df.columns.tolist()
        column_definitions = {}
        
        for column_name in column_names:
            match = data_dictionary_df[data_dictionary_df["Variable Name"] == column_name]
            if not match.empty:
                variable_type = match["Variable Type"].iloc[0]
                variable_length = match["Variable Length"].iloc[0]
                variable_format = match["Variable Format"].iloc[0] if "Variable Format" in match.columns else ""
                column_definitions[column_name] = map_variable_type_to_sql(
                    column_name, variable_type, variable_length, variable_format
                )
            else:
                # Treat as VARCHAR if not found in the data dictionary
                column_definitions[column_name] = 'VARCHAR'

        print(f"Processing file: {csv_file}")
        print("Column names and their assigned types from data dictionary:")

        # Generate the SQL model
        sql_file = os.path.splitext(csv_file.name)[0] + ".sql"
        sql_file_path = os.path.join("data_processing/models/ahrq.gov/generated/with_types", sql_file)
        with open(sql_file_path, "w") as f:
            # Write the SQL model header
            f.write(f"-- SQL model for {csv_file.name}\n")
            f.write(
                "{{ config(materialized='external', location=var('output_path') + '/' + this.name + '.parquet') }}\n\n"
            )

            # Write the SQL SELECT statement
            column_list = []
            types_list = []
            for column_name in column_names:
                if column_name in column_definitions:
                    data_type = column_definitions[column_name]
                    types_list.append(f"'{column_name}': '{data_type}'")
                    if "AMT" in column_name:
                        # remove dollar sign from the VARCHAR string
                        column_list.append(
                            f"replace(replace({column_name}, '$', ''), ',', '')::{data_type} AS {column_name}"
                        )
                    else:
                        column_list.append(
                            f"{column_name}::{data_type} AS {column_name}"
                        )
                else:
                    column_list.append(f"{column_name}::VARCHAR")
                    types_list.append(f"'{column_name}': 'VARCHAR'")

            types_str = ", ".join(types_list)
            username = os.environ.get("USER")
            path_without_user = "~/" + str(csv_file).split(username + '/')[1]
            select_statement = (
                "SELECT\n    " + ",\n    ".join(column_list) + "\n" +
                f"FROM read_csv('{path_without_user}', header=True, null_padding=true, types={{ {types_str} }}, ignore_errors=true)"
            )
            f.write(select_statement)

        print(f"Generated SQL model: {sql_file_path}")

def main(csv_folder):
    data_dictionary_df = create_data_dictionary()
    process_csv_files(data_dictionary_df, csv_folder)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python generate_syh_dr_data_models.py <csv_folder>")
        sys.exit(1)
    csv_folder = sys.argv[1]
    main(csv_folder)
