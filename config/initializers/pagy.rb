# frozen_string_literal: true

# Pagy is required in config/application.rb to guarantee load order.
# This file contains only runtime configuration defaults.

# Number of records per page
Pagy::DEFAULT[:limit] = 12

# Redirect to last page instead of raising error when page exceeds total
Pagy::DEFAULT[:overflow] = :last_page
