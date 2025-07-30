// highlight-reaction.js

import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "custom-reaction-highlight",

  initialize() {
    withPluginApi("0.8", api => {
      api.decorateWidget("post-contents:after", dec => {
        const post = dec.getModel();
        const currentUser = api.getCurrentUser();

        if (!currentUser) return;

        const userReaction = post.custom_fields?.custom_reactions?.[currentUser.id];

        const buttons = [
          { label: "👍 Çok Beğendim", type: "very_like" },
          { label: "🙂 Beğendim", type: "like" },
          { label: "🙁 Beğenmedim", type: "dislike" },
          { label: "👎 Hiç Beğenmedim", type: "very_dislike" },
        ];

        return dec.h("div.custom-reactions-buttons", {},
          buttons.map(({ label, type }) =>
            dec.h("button.reaction-button", {
              className: userReaction === type ? "highlighted" : "",
              onclick: () => sendReaction(post.id, type)
            }, label)
          )
        );
      });
    });
  }
};

function sendReaction(postId, reactionType) {
  fetch("/custom-reactions/react", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content
    },
    body: JSON.stringify({ post_id: postId, reaction_type: reactionType })
  })
    .then(res => res.json())
    .then(() => location.reload());
}