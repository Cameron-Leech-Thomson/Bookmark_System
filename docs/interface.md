# Presentation Layer

## Login

### HTTP Request

`POST /login`

| Parameter | Description   |
|-----------|---------------|
| em        | Email address |
| pwd       | Password      |

## Forget My Password (Future)

### HTTP Request

`POST /forgetpassword`

| Parameter | Description       |
|-----------|-------------------|
| em        | Email address     |
| otp       | One-Time-Password |

## General Search

### HTTP Request 

`GET /s`

| Parameter | Description|  Example                |
|-----------|------------|-------------------------|
| q         | Query field | q=google               |
| tags      | A list of tags attached to the bookmark. Seperated by hyphen.  | tags=edu-tech-md        |
| t         | Time interval in which bookmarks should be searched. Should be in the form of Unix timp stamp, seperated by hyphen. | t=1583070342-1583070352 |
| un        | Specify the user whole upload the bookmark.  | un=liwang               |

## Search for employee

### HTTP Request

`GET  /se`

| Parameter | Description                 |
|-----------|-----------------------------|
| q         | Query field                 |
| dq        | Department of the employee. |

## Open a bookmark detail page

### HTTP Request

`GET /bm`

| Parameter | Description                 |
|-----------|-----------------------------|
| id        | Primary key of the bookmark |

## Open a employee's profile

### HTTP Request

`GET /em`

| Parameter | Description                 |
|-----------|-----------------------------|
| id        | Primary key of the employee |
