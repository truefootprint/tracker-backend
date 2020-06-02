## Tracker Backend

This repository contains a Rails app that serves as the backend for the
[tracker-visualiser](https://github.com/truefootprint/tracker-visualiser)
project. Although it works and does some useful things, it is a prototype and
all the code should be thrown away (it's really bad). Currently many of the
tests are broken and there are some very hard-to-understand queries like
[this one](https://github.com/truefootprint/tracker-backend/blob/master/app/queries/company_rankings_query.rb).

The app is hosted on the same server as [FieldBackend](https://github.com/truefootprint/field-backend)
and is deployed by the [infrastructure](https://github.com/truefootprint/infrastructure)
project as part of its image.

### Spreadsheets

The app's data is sourced from spreadsheets:

- [Mining](https://docs.google.com/spreadsheets/d/1nOUkxV2CLpjYht-T8LsqrXRlGRJecsSrvlqBgNjLIzk/edit?ts=5d3b214c)
- [Fashion](https://docs.google.com/spreadsheets/d/1I0FGOfEOMEhCy822x9_gcAPP0vC23-utIqTyToT-rGY)
- [Luxury Fashion](https://docs.google.com/spreadsheets/d/11LtJDOLxmNY3XEvdDBZTJtggdiZB0UpjjgDIuZ_Nnmg)

These are in a strict format and are read by `app/services/importer.rb`. This
can be run manually by running:

```sh
$ ssh tracker-backend.truefootprint.com
$ cd tracker-backend
$ sudo service tracker-backend stop
$ DISABLE_DATABASE_ENVIRONMENT_CHECK=1 RAILS_ENV=production bundle exec rake db:drop db:create db:migrate
$ RAILS_ENV=production bundle exec rails c
> Importer.run
$ sudo service tracker-backend start
```

You should test the importer works first on your local machine before running on
production as it often breaks due to invalid data in the spreadsheet. The
spreadsheets are pulled from Google Sheets. You need to add the
`google-sheets.json` credentials to `config/` for this. Ask Edwin or Chris for
this if you don't have it.

### How to add a new spreadsheet

To add a new spreadsheet, follow these steps:

1. Make a copy of an existing working spreadsheet in Google Sheets
2. Modify it to add your new data
3. Share the sheet with the service account: truefootprint@truefootprint.iam.gserviceaccount.com
4. Add the lowercase name of your sheet into `self.run` of `app/services/importer.rb`
5. Add the same name to the `#auditor_start` method with the appropriate spreadsheet line number
6. Test the spreadsheet locally: clear the database then run `Importer.run` from a rails console
7. If this succeeds, start [tracker-visualiser](https://github.com/truefootprint/tracker-visualiser) locally to see the newly imported data
8. Visit the [#NewName-2018-group-1](http://localhost:3000/#NewName-2018-group-1) page (replacing 'NewName' with the actual name)
9. Once you are happy with the import, follow the steps above to update the server

If the import fails, you may need to step through the `importer.rb` code manually
with [pry](https://github.com/pry/pry) to identify the problem. A common problem
is a missing comma between the hyphen character (-) which represents a blank and
a data value in one of the company data points in the spreadsheet.
