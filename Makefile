.PHONY:= all clean test

run:
	poetry run jupyter lab
setup:
	poetry install
