---
name: linear
description: |
  Linear GraphQL patterns for Symphony agents. Use `linear_graphql` for all
  operations — comments, state transitions, PR attachments, file uploads, and
  issue creation. Never use schema introspection.
---

# Linear GraphQL

All Linear operations go through the `linear_graphql` client tool exposed by
Symphony's app server. It handles auth automatically.

```json
{
  "query": "query or mutation document",
  "variables": { "optional": "graphql variables" }
}
```

One operation per tool call. A top-level `errors` array means the operation
failed even if the tool call completed.

## Workpad

Maintain a local `workpad.md` in your workspace. Edit freely (zero API cost),
then sync to Linear at milestones — plan finalized, implementation done,
validation complete. Do not sync after every small change.

**First sync** — create the comment, save the ID:

```graphql
mutation CreateComment($issueId: String!, $body: String!) {
  commentCreate(input: { issueId: $issueId, body: $body }) {
    success
    comment { id }
  }
}
```

Write the returned `comment.id` to `.workpad-id` so subsequent syncs can update.

**Subsequent syncs** — read `.workpad-id`, update in place:

```graphql
mutation UpdateComment($id: String!, $body: String!) {
  commentUpdate(id: $id, input: { body: $body }) { success }
}
```

## Query an issue

The orchestrator injects issue context (identifier, title, description, state,
labels, URL) into your prompt at startup. You usually do not need to re-read.

When you do, use the narrowest lookup for what you have:

```graphql
# By ticket key (e.g. MT-686)
query($key: String!) {
  issue(id: $key) {
    id identifier title url description
    state { id name type }
    project { id name }
  }
}
```

For comments and attachments:

```graphql
query($id: String!) {
  issue(id: $id) {
    comments(first: 50) { nodes { id body user { name } createdAt } }
    attachments(first: 20) { nodes { url title sourceType } }
  }
}
```

## State transitions

Fetch team states first, then move with the exact `stateId`:

```graphql
query($id: String!) {
  issue(id: $id) {
    team { states { nodes { id name } } }
  }
}
```

```graphql
mutation($id: String!, $stateId: String!) {
  issueUpdate(id: $id, input: { stateId: $stateId }) {
    success
    issue { state { name } }
  }
}
```

## Attach a PR or URL

```graphql
# GitHub PR (preferred for PRs)
mutation($issueId: String!, $url: String!, $title: String) {
  attachmentLinkGitHubPR(issueId: $issueId, url: $url, title: $title, linkKind: links) {
    success
  }
}

# Plain URL
mutation($issueId: String!, $url: String!, $title: String) {
  attachmentLinkURL(issueId: $issueId, url: $url, title: $title) {
    success
  }
}
```

## File upload

Three steps:

1. Get upload URL:

```graphql
mutation($filename: String!, $contentType: String!, $size: Int!) {
  fileUpload(filename: $filename, contentType: $contentType, size: $size, makePublic: true) {
    success
    uploadFile { uploadUrl assetUrl headers { key value } }
  }
}
```

2. PUT file bytes to `uploadUrl` with the returned headers (use `curl`).
3. Embed `assetUrl` in comments/workpad as `![description](url)`.

## Issue creation

Resolve project slug to IDs first:

```graphql
query($slug: String!) {
  projects(filter: { slugId: { eq: $slug } }) {
    nodes { id teams { nodes { id key states { nodes { id name } } } } }
  }
}
```

Then create:

```graphql
mutation($input: IssueCreateInput!) {
  issueCreate(input: $input) {
    success
    issue { identifier url }
  }
}
```

`$input` fields: `title`, `teamId`, `projectId`, and optionally `description`,
`priority` (0–4), `stateId`. For relations, follow up with:

```graphql
mutation($input: IssueRelationCreateInput!) {
  issueRelationCreate(input: $input) { success }
}
```

Input: `issueId`, `relatedIssueId`, `type` (`blocks` or `related`).

## Repo project bootstrap

When a workflow needs a Linear project for a repository, use the repository name
as the canonical project name:

1. Query projects by exact `name`.
2. Reuse the exact active match if it exists.
3. Otherwise create a new project with that repo name and the intended team.
4. Persist the returned `slugId` anywhere workflow config expects a project slug.
5. Create follow-up issues under that same project by default.

Lookup:

```graphql
query($name: String!) {
  projects(filter: { name: { eq: $name } }) {
    nodes {
      id
      name
      slugId
      state
      teams { nodes { id key name } }
    }
  }
}
```

Create:

```graphql
mutation($input: ProjectCreateInput!) {
  projectCreate(input: $input) {
    success
    project { id name slugId }
  }
}
```

Minimum create input: `name`, `teamIds`.

## Rules

- **No introspection.** Never use `__type` or `__schema` queries. They return
  the entire Linear schema (~200K chars) and waste the context window. Every
  pattern you need is documented above.
- Keep queries narrowly scoped — ask only for fields you need.
- Sync the workpad at milestones, not after every change.
- For state transitions, always fetch team states first — never hardcode state IDs.
- Prefer `attachmentLinkGitHubPR` over generic URL attachment for GitHub PRs.
