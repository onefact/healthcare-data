import os
import sys
import pandas as pd
import requests
import tempfile
import pdfplumber


def process_csv_files(pdf_url, csv_folder):
    # Download the data dictionary PDF
    response = requests.get(pdf_url)
    with tempfile.NamedTemporaryFile(delete=False) as temp_file:
        temp_file.write(response.content)
        pdf_path = temp_file.name

    # Load the PDF file
    pdf = pdfplumber.open(pdf_path)

    # Define the CSV file names
    csv_files = [
        "syhdr_commercial_inpatient_2016.CSV",
        "syhdr_commercial_outpatient_2016.CSV",
        "syhdr_commercial_person_2016.CSV",
        "syhdr_commercial_pharmacy_2016.CSV",
        "syhdr_medicaid_inpatient_2016.CSV",
        "syhdr_medicaid_outpatient_2016.CSV",
        "syhdr_medicaid_person_2016.CSV",
        "syhdr_medicaid_pharmacy_2016.CSV",
        "syhdr_medicaid_provider_2016.csv",
        "syhdr_medicare_inpatient_2016.CSV",
        "syhdr_medicare_outpatient_2016.CSV",
        "syhdr_medicare_person_2016.CSV",
        "syhdr_medicare_pharmacy_2016.CSV",
        "syhdr_medicare_provider_2016.csv",
    ]

    # Process each CSV file
    for csv_file in csv_files:
        csv_path = os.path.join(csv_folder, csv_file)
        if not os.path.exists(csv_path):
            print(f"File not found: {csv_path}")
            continue

        # Load the CSV file into a pandas DataFrame
        df = pd.read_csv(csv_path, nrows=1)

        # Get the column names from the DataFrame
        column_names = df.columns.tolist()

        print(f"Processing file: {csv_file}")
        print("Column names:")
        print(column_names)
        print()

        # Initialize a dictionary to store the data types for each column
        column_definitions = {}

        # Search for each column name in the PDF pages
        csv_types = None
        for column_name in column_names:
            print(f"Processing column: {column_name}")
            data_type = None
            # Manually set the data type for some columns
            if "_DT" in column_name or "_DATE" in column_name:
                data_type = "DATE"
            elif "_ST_CD" in column_name:
                data_type = "VARCHAR"
            elif "CPT" in column_name:
                data_type = "VARCHAR"
                if csv_types is None:
                    csv_types = f"'{column_name}': 'VARCHAR'"
                else:
                    csv_types += f", '{column_name}': 'VARCHAR'"
            elif "_ID" in column_name and "CD" not in column_name:
                data_type = "UBIGINT"
            elif "LOS" in column_name:
                data_type = "UINTEGER"
            elif "AMT" in column_name:
                data_type = "FLOAT"

            for page_number in range(10, len(pdf.pages)):
                print(f"Searching for column '{column_name}' on page {page_number + 1}")
                page = pdf.pages[page_number]
                cropped_page = page.crop(
                    (72, 86.4, page.width - 72, page.height - 70.0)
                )
                text = cropped_page.extract_text()
                lines = text.split("\n")

                if column_name in text:
                    print(f"Column '{column_name}' found on page {page_number + 1}")

                    # Extract the first occurrence of "Character" or "Numeric" before the table start
                    if data_type is None:
                        if "Character" in lines:
                            data_type = "VARCHAR"
                        elif "Numeric" in lines:
                            data_type = "NUMERIC"
                        print(f"Data type for column '{column_name}': {data_type}")

                    if data_type:
                        column_definitions[column_name] = data_type
                        break  # Break the loop once the column is found and data type is extracted

            print()

        # Generate the SQL model
        sql_file = os.path.splitext(csv_file)[0] + ".sql"
        with open(os.path.join("models/generated/with_types", sql_file), "w") as f:
            # Write the SQL model header
            f.write(f"-- SQL model for {csv_file}\n")
            f.write(
                "{{ config(materialized='external', location=var('output_path') + '/' + this.name + '.parquet') }}\n\n"
            )

            # Write the SQL SELECT statement
            column_list = []
            for column_name in column_names:
                if column_name in column_definitions:
                    data_type = column_definitions[column_name]
                    if "AMT" in column_name:
                        # remove dollar sign from the VARCHAR string
                        column_list.append(
                            f"replace(replace({column_name}, '$', ''), ',', '')::{data_type} AS {column_name}"
                        )
                    else:
                        column_list.append(f"{column_name}::{data_type} AS {column_name}")
                else:
                    column_list.append(f"{column_name}::VARCHAR")

            if csv_types:
                open_bracket = "{"
                close_bracket = "}"
                csv_str = f", types={open_bracket}{csv_types}{close_bracket}, ignore_errors=true"
                print(csv_str)
            select_statement = f"SELECT\n    {',\n    '.join(column_list)}\nFROM read_csv('{csv_path}', header=True, null_padding=true{csv_str if csv_types else ''})"
            f.write(select_statement)

        print(f"Generated SQL model: {sql_file}")
        print()

    # Clean up the temporary PDF file
    os.unlink(pdf_path)


def main(csv_folder, data_dictionary_url):
    process_csv_files(data_dictionary_url, csv_folder)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print(
            "Usage: python generate_syh_dr_sql_models.py <csv_folder> <data_dictionary_url>"
        )
        sys.exit(1)
    csv_folder = sys.argv[1]
    data_dictionary_url = sys.argv[2]
    main(csv_folder, data_dictionary_url)
