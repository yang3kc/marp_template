# Marp Slides PDF Generation Makefile
# Converts Markdown slides to PDF using Marp CLI

# Directories
PDF_DIR = PDFs
MARP_CLI = npx @marp-team/marp-cli@latest

# Find all .md files excluding README.md and template files
MD_FILES = $(shell find . -name "*.md" -not -name "README.md" -not -name "CLAUDE.md" -not -name "example.md" -type f)

# Generate PDF paths maintaining directory structure
PDF_FILES = $(patsubst ./%.md,$(PDF_DIR)/%.pdf,$(MD_FILES))

# Extract directory structure for PDFs
PDF_DIRS = $(sort $(dir $(PDF_FILES)))

# Default target
.PHONY: all clean distclean help setup list

all: setup $(PDF_FILES)

# Create necessary directories
setup:
	@mkdir -p $(PDF_DIR)
	@for dir in $(PDF_DIRS); do mkdir -p $$dir; done

# Convert individual markdown files to PDF
$(PDF_DIR)/%.pdf: %.md | setup
	@echo "Converting $< to PDF..."
	@$(MARP_CLI) $< -o $@ --pdf --theme-set themes/*.scss --allow-local-files

# Clean generated files
clean:
	@echo "Cleaning generated PDF files..."
	@rm -rf $(PDF_DIR)

# Alias for clean
distclean: clean

# Help target
help:
	@echo "Marp Slides PDF Generation System"
	@echo "Usage:"
	@echo "  make all        - Generate all slide PDFs"
	@echo "  make clean      - Remove all generated PDFs"
	@echo "  make setup      - Create necessary directories"
	@echo "  make list       - Show available markdown files"
	@echo ""
	@echo "Markdown files will be converted to: $(PDF_DIR)/"
	@echo ""
	@echo "Individual file targets (examples):"
	@echo "  make $(PDF_DIR)/slides/my_deck.pdf"

# Show available markdown files
list:
	@echo "Available markdown slide files:"
	@for file in $(MD_FILES); do echo "  $$file"; done
	@echo ""
	@echo "Will generate $(words $(PDF_FILES)) PDF files"
