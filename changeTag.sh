#!/bin/bash
sed "s/tagVersion/$1/g" pods.yml > java-jsp-diary-pod.yml
