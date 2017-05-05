#!/bin/sh

psql -c 'alter table ut  add rekt integer default 0,  add rektme integer default 0;   update ut  set rekt=0, rektme=0'

