RM=/bin/rm -rf
TEMPLATE = templates/template2.html
COMBINED_YAML = build/portfolio.yaml
HTML_PORTFOLIO = docs/index.html
CSS_PATH  = assets/css/

PROJECTS = $(wildcard src/projects/*.yaml)
BEFORE_PROJECTS = src/00-portfolio-start.yaml
AFTER_PROJECTS = src/99-portfolio-end.yaml
PORTFOLIO_FILES = $(BEFORE_PROJECTS) $(PROJECTS) $(AFTER_PROJECTS)


SCSS_FILE = $(wildcard $(CSS_PATH)*.scss)
CSS_FILE = $(SCSS_FILE:.scss=.css)

$(HTML_PORTFOLIO): $(COMBINED_YAML)
	pandoc --template=$(TEMPLATE) $^ -o $@

$(COMBINED_YAML): $(PORTFOLIO_FILES)
	cat $^ > $@

$(CSS_PATH)%.css: $(CSS_PATH)%.scss
	sass $< $@

.PHONY: all again

all: css portfolio-yaml portfolio

again: clean all

css: $(CSS_FILE) $(SCSS_FILE)

portfolio: $(HTML_PORTFOLIO) $(TEMPLATE) $(COMBINED_YAML)
portfolio-again: clean-yaml clean-portfolio portfolio-yaml portfolio
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