"""Aufruf: python -m motions vorschau [namen…]  |  python -m motions backen

vorschau: Bildreihen der Bewegungen nach tools/motions/vorschau/ (oder --ziel ORDNER)
backen:   neue Bewegungen in FitScan/FitScan_Motions.bin schreiben und FitScan/BodyMotions.swift erzeugen
"""
import sys

from .bake import main

main(sys.argv[1:])
