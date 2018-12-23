.PHONY: all
all: project

NAME := $(shell basename `pwd`)

.PHONY: project
project: $(NAME).xcodeproj

$(NAME).xcodeproj: Package.swift FORCE
	@swift package generate-xcodeproj --enable-code-coverage

.PHONY: clean
clean:
	@swift package clean
	@$(RM) -r ./$(NAME).xcodeproj

FORCE: