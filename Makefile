# Adapted from https://gist.github.com/bertvv/e77e3a5d24d8c2a9bcc4
# Generate PDFs from the ChordPro source files


# Directory containing source files 
source := src

# Directory containing pdf files
output := print
songbook := $(output)/_songbook.pdf

# All .pro files in src/ are considered sources
sources := $(wildcard $(source)/*.pro)

# Convert the list of source files (.pro files in directory src/)
# into a list of output files (PDFs in directory print/).
objects := $(patsubst %.pro,%.pdf,$(subst $(source),$(output),$(sources)))

all: $(objects)

# Recipe for converting a ChordPro file into PDF and stamping on a watermark
# Remove/comment the last two lines (pdftk, mv), if you don't need the bsp watermark
$(output)/%.pdf: $(source)/%.pro
	@echo Making "$(@)"
	@chordpro "$(<)" --config=config/songsheet.json -o "$(@)"
#	@pdftk "$(@)" stamp static/watermark/watermark.compressed.pdf output "$(@)_"
#	@mv "$(@)_" "$(@)"



.PHONY: songbook
songbook:
	@echo Making "$(songbook)"
	@ls src/* > src/songbook.txt
	@chordpro --filelist=src/songbook.txt --config=config/songsheet.json --config=config/songbook.json -p 2 --no-csv --cover=static/cover/cover.pdf -o "$(songbook)"
	@rm src/songbook.txt

.PHONY: clean
clean:
	rm -f $(output)/*.pdf
