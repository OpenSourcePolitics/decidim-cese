/* eslint-disable multiline-ternary, no-ternary */

/*
 * Triggered when adding data-after-action to a link or button
 *
 * This is used to add an after action after sign in.
 *
 * When a button or link trigger a login modal we capture
 * the event and inject the after action to be done 
 * after sign in (the after_action param).
 *
 * The code is injected to any form or link in the modal
 * and when the modal is closed we remove the injected
 * code.
 *
 * In order for this to work the button or link must have
 * a data-open attribute with the ID of the modal to open
 * and a data-after-action attribute the action to be done. 
 * If any of this is missing no code will be injected.
 */
$(() => {
  const removeAfterActionParameter = (url, parameter) => {
    const urlParts = url.split("?");

    if (urlParts.length >= 2) {
      // Get first part, and remove from array
      const urlBase = urlParts.shift();

      // Join it back up
      const queryString = urlParts.join("?");

      const prefix = `${encodeURIComponent(parameter)}=`;
      const parts = queryString.split(/[&;]/g);

      // Reverse iteration as may be destructive
      for (let index = parts.length - 1; index >= 0; index -= 1) {
        // Idiom for string.startsWith
        if (parts[index].lastIndexOf(prefix, 0) !== -1) {
          parts.splice(index, 1);
        }
      }

      if (parts.length === 0) {
        return urlBase;
      }

      return `${urlBase}?${parts.join("&")}`;
    }

    return url;
  }

  $(document).on("click.zf.trigger", (event) => {
    const target = `#${$(event.target).data("open")}`;
    const afterAction = $(event.target).data("afterAction");

    if (target && afterAction) {
      $("<input type='hidden' />").
        attr("id", "after_action").
        attr("name", "after_action").
        attr("value", afterAction).
        appendTo(`${target} form`);

      $(`${target} a`).attr("href", (index, href) => {
        const querystring = jQuery.param({"after_action": afterAction});
        return href + (href.match(/\?/) ? "&" : "?") + querystring;
      });
    }
  });

  $(document).on("closed.zf.reveal", (event) => {
    $("#after_action", event.target).remove();
    $("a", event.target).attr("href", (index, href) => {
      if (href && href.indexOf("after_action") !== -1) {
        return removeAfterActionParameter(href, "after_action");
      }

      return href;
    });
  });
});
