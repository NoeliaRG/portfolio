RM=/bin/rm -rf

FILES_PATH = portfolio-files/
PROJECTS_PATH = $(FILES_PATH)projects/
PROJECTS = $(wildcard $(PROJECTS_PATH)*.yaml)
BEFORE_PROJECTS = $(FILES_PATH)00-portfolio-start.yaml
AFTER_PROJECTS = $(FILES_PATH)99-portfolio-end.yaml
PORTFOLIO_FILES = $(BEFORE_PROJECTS) $(PROJECTS) $(AFTER_PROJECTS)

CSS_PATH  = assets/css/
SCSS_FILE = $(wildcard $(CSS_PATH)*.scss)
CSS_FILE = $(SCSS_FILE:.scss=.css)

TEMPLATE = assets/templates/portfolio-template.html
COMBINED_YAML = portfolio.yaml
HTML_PORTFOLIO = portfolio.html



$(HTML_PORTFOLIO): $(COMBINED_YAML)
	pandoc --template=$(TEMPLATE) $^ -o $@

$(COMBINED_YAML): $(PORTFOLIO_FILES)
	cat $^ > $@

$(CSS_FILE): $(SCSS_FILE)
	sass $^ $@


.PHONY: all again

all: css portfolio-yaml portfolio

again: clean all

css: $(CSS_FILE) $(SCSS_FILE)

portfolio: $(HTML_PORTFOLIO) $(TEMPLATE) $(COMBINED_YAML)

portfolio-yaml: $(COMBINED_YAML) $(PORTFOLIO_FILES)

#USEFUL RULES
#Rule to print any variable. To use write 'make print-VARIABLE' in the terminal
print-%  : ; @echo $* = $($*)

clean: clean-yaml clean-portfolio clean-css

clean-portfolio:
	$(RM) $(HTML_PORTFOLIO)
clean-yaml:
	$(RM) $(COMBINED_YAML)
clean-css:
	$(RM) $(CSS_FILE) $(CSS_FILE).map