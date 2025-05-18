# CSV File Import Application - Reservations

This application allows importing CSV files containing reservation lists with information about the buyer, event, and pricing.

## Features

- **CSV File Import**  
  A dedicated page lets users select and upload a CSV file.

- **Column Matching System**  
  A column matching feature ensures uniform data import regardless of the original CSV file structure.

- **Background Processing with Sidekiq**  
  Data import is handled as a background job using Sidekiq, allowing large files to be processed without blocking the user interface.

- **Intermediate Table for Import**  
  A temporary table stores raw CSV data to facilitate and speed up the import process.

- **Dashboard with Filters**  
  A second page acts as a dashboard where users can filter reservations by event and view associated data.

## Deployment

The application has been deployed and is available online at:  
[https://reservation-app.martinforget.fr/](https://reservation-app.martinforget.fr/)  

Feel free to access it and test the import and dashboard features.

## How to get started

1. Clone the repository

2. Install dependencies

`bundle install`

3. Set up the database

`rails db:create db:migrate`

4. Start Sidekiq

`bundle exec sidekiq`

5. Start the server

`rails server`

## Tests

Tests have been added. You can run them with the following command:

`rspec`