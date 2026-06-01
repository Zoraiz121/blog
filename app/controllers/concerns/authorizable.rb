# frozen_string_literal: true

# Authorizable — shared authorization helpers for all controllers.
#
# Included in ApplicationController so every controller inherits
# these methods without any explicit include.
#
# Provides two complementary authorization tools:
#
# 1. own?(record)
#    A predicate that returns true if the current user owns the record.
#    Works with any model that has a user_id foreign key.
#    Use this in views to show/hide UI elements based on ownership.
#
#    Examples:
#      <% if own?(@article) %>
#        <%= link_to "Edit", edit_article_path(@article) %>
#      <% end %>
#
# 2. require_ownership!(record)
#    An enforcement method for controller before_actions.
#    Redirects with an alert if the current user does not own the record.
#    Use this as a safety net — primary ownership should still be
#    enforced at the query level (current_user.articles.find) where possible.
#
#    Examples:
#      before_action :set_article
#      before_action -> { require_ownership!(@article) }, only: [:edit]
#
# Authorization Philosophy:
#   Primary layer:   Query scoping   current_user.articles.find(id)
#                    → RecordNotFound if not owner (404 response)
#                    → Cannot be bypassed even if before_action is skipped
#
#   Secondary layer: require_ownership!(record)
#                    → Explicit redirect with alert (403-equivalent response)
#                    → Used when query scoping is not possible (e.g. comments
#                       where we need the article scope AND user scope together)
#
#   View layer:      own?(record)
#                    → Hides edit/delete UI from non-owners
#                    → Never a security guarantee — always back with controller

module Authorizable
  extend ActiveSupport::Concern

  included do
    # Make own? available in views as a helper method.
    # Controllers can call own?(@article) and so can .html.erb templates.
    helper_method :own?
  end

  # own?(record) — predicate for ownership checks in views and controllers.
  #
  # Returns true if:
  #   - A user is signed in (current_user is not nil)
  #   - The record responds to user_id (has the foreign key column)
  #   - The record's user_id matches the current user's id
  #
  # Returns false safely for any nil record or unauthenticated request
  # so views can always call own?(@article) without nil guards.
  #
  # @param record [ActiveRecord::Base] any model with a user_id column
  # @return [Boolean]
  def own?(record)
    return false unless current_user
    return false unless record.respond_to?(:user_id)

    record.user_id == current_user.id
  end

  # require_ownership!(record) — enforcement for controller before_actions.
  #
  # Redirects to root with an alert if the current user does not own
  # the record. Call this in before_actions for any action that mutates
  # a record that cannot be query-scoped to the current user.
  #
  # On redirect, preserves the request's back URL if available via
  # the HTTP Referer header — sends the user back to where they came from
  # rather than always dumping them on the root path.
  #
  # @param record [ActiveRecord::Base] any model with a user_id column
  # @return [void] redirects and halts the filter chain on failure
  def require_ownership!(record)
    return if own?(record)

    redirect_back_or_to root_path,
                         alert: "You are not authorized to perform this action."
  end
end
