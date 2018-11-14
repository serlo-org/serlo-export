# catch rules for targets with references to latest revision
$(EXPORT_DIR)/$(ARTICLE_BOOK)/%stats.html: $(TARGET_RESOLVED_REVISION) $(HAS_LATEST_GUARD)
	$(LINK_BOOK_LATEST)
	$(LINK_LATEST_TARGET)

$(EXPORT_DIR)/%book.stats.html: $(TARGET_RESOLVED_REVISION) $(HAS_LATEST_GUARD)
	$(LINK_BOOK_LATEST)
	$(LINK_LATEST_TARGET)

$(EXPORT_DIR)/%.lints.yml: $(ORIGIN_SECONDARY)
	$(MK)/bin/mwlint \
		--texvccheck-path $(MK)/bin/texvccheck \
	< $< > $@

# TODO: stats.html does not contain lint info.
$(EXPORT_DIR)/%.stats.html: $(EXPORT_DIR)/%.stats.yml $(EXPORT_DIR)/%.lints.yml
	$(eval $(parse_booktarget))
	$(MK)/bin/handlebars-cli-rs \
		--input $(BASE)/templates/article_stats.html \
		--data '$<' \
		article '$(call unescape,$(ARTICLE))' \
		revision $(ARTICLE_REVISION) \
	> $@

$(EXPORT_DIR)/%.book.stats.yml: $(PARSE_PATH_SECONDARY) $$(BOOK_DEP_FILE) $$(BOOK_DEP_INTERMEDIATE) $(NO_LATEST_GUARD)
	(cd $(dir $@) && python $(MK)/scripts/collect_stats.py > $(notdir $@))

# final book index, depends dependency file which adds its dependencies
# only applies for resolved dependencies
$(EXPORT_DIR)/%.book.stats.html: $(EXPORT_DIR)/%.book.stats.yml $(PARSE_PATH_SECONDARY) $(NO_LATEST_GUARD)
	$(eval $(parse_booktarget))
	$(MK)/bin/handlebars-cli-rs \
		--input templates/stats.html \
		--data $< \
		book '$(call unescape,$(BOOK))' \
		book_revision $(BOOK_REVISION) \
	> $@