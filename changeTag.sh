#!/bin/bash
sed "s/tagVersion/$1/g" pod.yml > java-jsp-diary-pod.yml
