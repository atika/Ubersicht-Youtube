Übersicht | Youtube Widget
=================
:closed_book: [Übersicht Homepage](http://tracesof.net/uebersicht/)
&nbsp;&nbsp;&nbsp;:pushpin: [Übersicht Widgets](http://tracesof.net/uebersicht-widgets/)
&nbsp;&nbsp;&nbsp;:page_facing_up: [Widgets GitHub Repo](https://github.com/felixhageloh/uebersicht-widgets)

The Widget displays public statistics of a __YouTube__ channel on your macOS desktop with [Übersicht](http://tracesof.net/uebersicht/).

![Youtube Übersicht Widget](./screenshot.png)

## Installation

Put the widget into the __Übersicht Widget folder__ and the __command line utility `ubersicht-youtube` where you want__.

A **YouTube API Key** is required to use the command line utility. Get your API Key for YouTube on the [Google Developer Console](https://console.developers.google.com).

## Change command path
Change the __absolute path of the command__ in the widget script.
```
command: """/path/to/ubersicht-youtube -key="XXXXXX" -username="channelname" -position="BL|20|120" -lang="FR" -showname -logored """
```

Alternatively you can write a shell script to execute this command and put the path to your script here.

## Command Line utility usage

The utility has been rewritten from the ground in [Golang](https://golang.org). It connect to the Youtube API and return the informations about the channel and the theme configuration in JSON format.

The `config.json` has been removed, you execute the utility with different parameters and it returns the configuration JSON for the widget.

```
./ubersicht-youtube -h
```

### Parameters

`-key` and `-id` or `-username` are required parameters.

| id | type | description |
| --- | --- | --- |
|   `-key`     | string  | YouTube Api Key          |
|   `-id`      | string  | YouTube channel ID       |
|  `-username` | string  | YouTube channel username |

| id | type | description |
| --- | --- | --- |
|  `-position` | string | Widget position (see below) |
| `-backcolor` | string | Widget background color |
| `-lang` |  string | Widget language (US, FR, PT) (default "US") |
| `-logoalpha` | float | Widget logo opacity (default 0.9) |
|  `-logored` | bool |    	Red YouTube logo (default "white logo")
|  `-showname` | bool | Display channel name |

**Position**

- Top Left:  ```TL|left_margin|top_margin```
- Top Right: ```TR|right_margin|top_margin```
- Bottom Left: ```BL|left_margin|bottom_margin```
- Bottom Right: ```BR|right_margin|bottom_margin```
- Center on screen: ```C|0|0```

To put the widget on bottom left of the screen, with left margin of 100px and bottom margin of 120px, write:

```
-position="BL|100|120"
```

**Examples**

Simple usage with channel username
```
./ubersicht-youtube -key="XXX" -username="redbull"
```
For a channel ID
```
./ubersicht-youtube -key="XXX" -id="XXXXX"
```

Full Exemple
```
./ubersicht-youtube -key="XXX" -username="redbull" -position="BL|50|120" -backcolor="rgba(0,0,0,0.95)" -lang="FR" -logoalpha="1.0" -logored -showname
```

### Result

```
{
  "user": "redbull",
  "displayname": "Red Bull",
  "stats": {
    "subscribers": 8033409,
    "views": 2100316125,
    "uploads": 6620
  },
  "statsf": {
    "subscribers": "8.0M",
    "subscribers2": "8.033.409",
    "views": "2.100.316.125",
    "uploads": "6.620"
  },
  "theme": {
    "back_color": "rgba(0,0,0,0)",
    "position": "BL|40|100",
    "logo_alpha": 0.9,
    "logo_red": true,
    "show_name": true,
    "lang": "US"
  }
}
```


