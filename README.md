# freemarker-templates

## parse-object.ftl

### string
**scripts?: string | scripts: string:**

`
<#assign foo = {
    "scripts": ""
}>
`

**client: object:**

`
<#assign foo = {
    "client": {
        "clientId": "",
        "name": "",
        "description": ""
    }
}>
`

**auth?: object:**

`
<#assign additional = {
    "auth.": { "selectedCredential": "" }
}>
<#assign foo = {
    "auth": "maybe_object"
}>
`

`
<#assign additional = {
    "test.auth.": { "selectedCredential": "" }
}>
<#assign foo = {
    "test": {
      "auth": "maybe_object"
    }
}>
`

**auth: unknow_object:**

`
<#assign foo = {
    "auth": "standard"
}>
`

**scripts: string[]:**

You need to add the first element.
`
<#assign foo = {
    "scripts": [""]
}>
`

**scripts: object[]:**

`
<#assign foo = {
    "supported": [ { "url": "", "languageTag": "" } ]
}>
`

**scripts?: object[]:**

`
<#assign additional = {
    "supported.": [ { "url": "", "languageTag": "" } ]
}>
<#assign foo = {
    "supported": "maybe_array"
}>
`

