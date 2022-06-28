# pastebin

A Common Lisp client to post, view, and delete your pastebin posts.

It pretty much exactly follows the docs at
https://pastebin.com/doc_api

The four exported functions are:

* get-user-key - This generates a user key for use with the other
  three functions. A user key is not required for anonymous functions,
  but is necessary for any function related to your account. User keys
  are persistent, so the last one created is good forever, until a new
  key is generated. If you've cached your key, you can simply re-use
  it.

* new-paste - This creates a new "paste". Some options, such as a
  private paste, require a user key. The format string is optional,
  but if supplied, must be valid (see doc link above). Likewise, the
  same is try for the expiry date.

* list-pastes - Return a list of all current pastes.

* delete-paste - Deletes a paste. A required parameter is the paste
  key, which is part of the data returned by list-pastes.
