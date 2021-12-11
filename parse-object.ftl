<html>
<head>
<script>
<#assign template="register.ftl" />
<#assign additional = {
    "auth.": {},
    "locale.": {
        "current": "",
        "supported": [ { "url": "", "languageTag": "" } ]
    },
    "message.": {
        "type": "",
        "summary": ""
    },
    "social.providers.": [{ "loginUrl": "", "alias": "", "providerId": "", "displayName": "" }],
    "client.": { "baseUrl": "" }
}>
<#assign foo = {
    "url": {
        "loginAction": "",
        "resourcesPath": "",
        "resourcesCommonPath": "",
        "loginRestartFlowUrl": "",
        "loginUrl": ""
    },
    "realm": "standard",
    "auth": "maybe_object",
    "scripts": [""],
    "locale": "maybe_object",
    "isAppInitiatedAction": false,
    "message": "maybe_object",
    "client": {
        "clientId": "",
        "name": "",
        "description": ""
    }

}>
<#switch template>
  <#case "login.ftl">
     <#assign foo += { "url": foo.url + { "loginResetCredentialsUrl": "", "registrationUrl": "" } } />
     <#assign foo += { "realm": foo.realm + { "loginWithEmailAllowed": false, "rememberMe": false, "password": false, "resetPasswordAllowed": false, "registrationAllowed": false } } />
     <#assign additional += { "auth.": additional["auth."] + { "selectedCredential": "" } } />
     <#assign foo += { "registrationDisabled": false, "usernameEditDisabled": false } />
     <#assign foo += { "login": { "username": "", "rememberMe": false } } />
     <#assign foo += { "social": { "displayInfo": false, "providers": "maybe_array" } } />
     <#break>
  <#case "register.ftl">
    <#assign foo += { "url": foo.url + { "registrationAction": "" } } />
    <#assign foo += { "passwordRequired": false, "recaptchaRequired": false, "recaptchaSiteKey": "" } />
    <#assign foo += { "social": { "displayInfo": false, "providers": "maybe_array" } } />
    <#assign foo += { "register": { "formData": { "firstName": "", "displayName": "", "lastName": "", "email": "", "username": "" } } } />
    <#break>
  <#case "register-user-profile.ftl">
      <#assign foo += { "url": foo.url + { "registrationAction": "" } } />
      <#assign foo += { "passwordRequired": false, "recaptchaRequired": false, "recaptchaSiteKey": "" } />
      <#assign foo += { "social": { "displayInfo": false, "providers": "maybe_array" } } />
      <#assign foo += { "profile": { "context": "", "attributes": "standard", "attributesByName": "standard" } } />
      <#break>
  <#case "info.ftl">
      <#assign foo += { "messageHeader": "", "requiredActions": "", "skipLink": false, "pageRedirectUri": "", "actionUri": "", "client": { "baseUrl": "" } } />
      <#break>
  <#case "error.ftl">
      <#assign foo += { "client": "maybe_object" } />
      <#break>
  <#case "login-reset-password.ftl">
      <#assign foo += { "realm": { "loginWithEmailAllowed": false } } />
      <#break>
  <#case "login-otp.ftl">
      <#assign foo += { "otpLogin": { "userOtpCredentials": [{ "id": "", "userLabel": "" }] } } />
      <#break>
  <#case "login-update-profile.ftl">
      <#assign foo += { "user": { "editUsernameAllowed": false, "username": "", "email": "", "firstName": "", "lastName": "" } } />
      <#break>
  <#case "login-idp-link-confirm.ftl">
      <#assign foo += { "idpAlias": "" } />
      <#break>
  <#case "login-idp-link-confirm.ftl">
      <#assign foo += { "mode": "", "totp": { "policy": { "supportedApplications": [""] } } } />
      <#break>
  <#default>
</#switch>
console.log('loginAction', ${.data_model.realm.internationalizationEnabled?c})

var myExtraData2 = JSON.parse(JSON.stringify(<@parse_object_known object=foo data=[] other=additional other_keys="" />), (key, value) => value === "is_undefined_for_replacement" ? undefined : value);
console.log('myExtraData2', myExtraData2);




</script>
<#function get_value arr>
<#if arr?sequence?size == 0>
    <#return .data_model>
</#if>
<#if arr?sequence?size == 1>
    <#return .data_model[arr[0]]>
</#if>
<#if arr?sequence?size == 2>
    <#return .data_model[arr[0]][arr[1]]>
</#if>
<#if arr?sequence?size == 3>
    <#return .data_model[arr[0]][arr[1]][arr[2]]>
</#if>
<#if arr?sequence?size == 4>
    <#return .data_model[arr[0]][arr[1]][arr[2]][arr[3]]>
</#if>
<#if arr?sequence?size == 5>
    <#return .data_model[arr[0]][arr[1]][arr[2]][arr[3]][arr[4]]>
</#if>
<#if arr?sequence?size == 6>
    <#return .data_model[arr[0]][arr[1]][arr[2]][arr[3]][arr[4]][arr[5]]>
</#if>
<#if arr?sequence?size == 7>
    <#return .data_model[arr[0]][arr[1]][arr[2]][arr[3]][arr[4]][arr[5]][arr[6]]>
</#if>
<#return ''>
</#function>

<#function get_string root key>
<#attempt>
    <#if (root[key])?? && root[key]?is_string>
        <#return "${root[key]}">
    <#else>
        <#return "is_undefined_for_replacement">
    </#if>
<#recover>
    <#return "is_undefined_for_replacement">
</#attempt>
</#function>

<#macro parse_object_known object data other other_keys>
    <@compress>

        {${'\n'}
        <#if object?is_hash || object?is_hash_ex>

        <#list object as key, value>
            <#local this_key=other_keys+key+".">
            <#if value?is_hash || value?is_hash_ex>
              "${key}": <@parse_object_known object=value data=data+[key] other=other other_keys=this_key />,
              <#continue>
            </#if>

            <#if value?is_string && value == "maybe_object" && (get_value(data)[key])?? && (other[this_key])??>
                "${key}": <@parse_object_known object=other[this_key] data=data+[key] other=other other_keys=this_key />,
                <#continue>
            </#if>

            <#if value?is_sequence || (value?is_string && value == "maybe_array")>
                <#local array=value>
                <#if value?is_string && value == "maybe_array" && (other[this_key])??>
                    <#local array=other[this_key]>
                </#if>
                <#attempt>
                    <#if (get_value(data)[key])?? && get_value(data)[key]?is_sequence && get_value(data)[key]?sequence?size gte 1 >
                        <#if array[0]?is_string && get_value(data)[key][0]?is_string>
                            "${key}": [<#list get_value(data)[key] as item>"${item?no_esc!"is_undefined_for_replacement"}",</#list>],
                        </#if>
                        <#if array[0]?is_hash && get_value(data)[key][0]?is_hash>
                            <#local counter=0>
                            "${key}": [<#list get_value(data)[key] as item>
                                <@parse_object_known object=array[0] data=data+[key]+[counter] other=other other_keys=this_key />,
                                <#local counter += 1>
                            </#list>],
                        </#if>
                    <#else>
                        "${key}": [],
                    </#if>
                <#recover>
                    "${key}": [],
                </#attempt>
                <#continue>
            </#if>

            <#if value?is_string && value == "standard">
                "${key}": <@objectToJson_please_ignore_errors object=get_value(data)[key] depth=0 />,
                <#continue>
            </#if>

            <#if value?is_string>
                <#attempt>
                    <#if (get_value(data)[key])?? && get_value(data)[key]?is_string>
                        "${key}": "${get_value(data)[key]?replace('"', '\\"')?no_esc!"is_undefined_for_replacement"}",
                    <#else>
                        "${key}": "is_undefined_for_replacement",
                    </#if>
                <#recover>
                    "${key}": "is_undefined_for_replacement",
                </#attempt>
                <#continue>
            </#if>

            <#if value?is_boolean && key??>
                <#attempt>
                    <#if (get_value(data)[key])?? && get_value(data)[key]?is_boolean>
                        "${key}": ${get_value(data)[key]?c!false},
                    <#else>
                        "${key}": false,
                    </#if>
                <#recover>
                    "${key}": false,
                </#attempt>
                <#continue>
            </#if>

            "${key}": "is_undefined_for_replacement",

        </#list>

        </#if>
        }${'\n'}
        <#return>

    </@compress>
</#macro>


<#macro objectToJson_please_ignore_errors object depth>
    <@compress>
        <#local isHash = false>
        <#attempt>
            <#local isHash = object?is_hash || object?is_hash_ex>
        <#recover>
            /* can't evaluate if object is hash */
            undefined
            <#return>
        </#attempt>
        <#if isHash>
            <#local keys = "">
            <#attempt>
                <#local keys = object?keys>
            <#recover>
                /* can't list keys of object */
                undefined
                <#return>
            </#attempt>
            {${'\n'}
            <#list keys as key>
                <#if key == "class">
                    /* skipping "class" property of object */
                    <#continue>
                </#if>

                <#attempt>
                    <#local value = object[key]!"is_undefined_for_replacement">
                <#recover>
                    /* couldn't dereference ${key} of object */
                    <#continue>
                </#attempt>
                <#if depth gt 7>
                    /* Avoid calling recustively too many times depth: ${depth}, key: ${key} */
                    <#continue>
                </#if>
                "${key}": <@objectToJson_please_ignore_errors object=value depth=depth+1/>,
            </#list>
            }${'\n'}
            <#return>
        </#if>
        <#local isMethod = "">
        <#attempt>
            <#local isMethod = object?is_method>
        <#recover>
            /* can't test if object is a method */
            undefined
            <#return>
        </#attempt>
        <#if isMethod>
            undefined
            <#return>
        </#if>
        <#local isBoolean = "">
        <#attempt>
            <#local isBoolean = object?is_boolean>
        <#recover>
            /* can't test if object is a boolean */
            undefined
            <#return>
        </#attempt>
        <#if isBoolean>
            ${object?c}
            <#return>
        </#if>
        <#local isEnumerable = "">
        <#attempt>
            <#local isEnumerable = object?is_enumerable>
        <#recover>
            /* can't test if object is enumerable */
            undefined
            <#return>
        </#attempt>
        <#if isEnumerable>
            [${'\n'}
            <#list object as item>
                <@objectToJson_please_ignore_errors object=item depth=depth+1/>,
            </#list>
            ]${'\n'}
            <#return>
        </#if>
        <#attempt>
            "${object?replace('"', '\\"')?no_esc}"
        <#recover>
            /* couldn't convert into string non hash, non method, non boolean, non enumerable object */
            undefined;
            <#return>
        </#attempt>
    </@compress>
</#macro>



  <title>Welcome!</title>
</head>
<body>
<h1>Welcome!</h1>
</body>
</html>
