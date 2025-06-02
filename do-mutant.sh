#!/bin/bash

RAILS_ENV=test bundle exec mutant run $@
