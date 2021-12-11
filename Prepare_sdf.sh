#!/bin/bash
/fsx/openbabel/bin/obabel -isdf $1 -osdf -O /fsx/sdf/$2_.sdf -p 7.4 -m
