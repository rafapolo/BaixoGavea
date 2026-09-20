# BaixoGavea

Rails app for baixogavea.com — a Brazilian music download site: browse bands
and albums, add links to tracks, vote on whether a link still works, and
search. Rebuilt on modern Ruby/Rails from the original 2010-era Rails 2
codebase; see "What changed" below for what was carried over versus dropped.

## Requirements

* Ruby 4.0.7 (see `.ruby-version`)
* SQLite 3

## Setup

```
bundle install
bin/rails db:setup      # creates the db, loads the schema, runs db/seeds.rb
```

## Running it

```
bin/rails server
```

Visit http://localhost:3000. The seeded user is `polo` / `polopolo`.

## Tests

```
bin/rails test
```

## What changed from the original Rails 2 app

Carried over: the core domain (users, bandas, albuns, links, votos,
trackers/torrents metadata), the same Portuguese URLs and route shapes, and
the letter-browse/search/stats/sitemap features.

Dropped as unmaintainable legacy/external dependencies rather than ported:
* Hand-rolled `.torrent` file upload and bencode parsing, and live
  seed/leech scraping against external BitTorrent trackers.
* The Google Images scraper used to auto-fill album art.
* The Twitter bot integration that announced new links.
* Email delivery (account confirmation, broken-link notifications) — new
  accounts are confirmed immediately instead of via an emailed link.

Security improvement: passwords are now hashed with bcrypt
(`has_secure_password`) instead of stored/compared in plain text.
