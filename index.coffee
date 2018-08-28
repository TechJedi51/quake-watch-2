#Quake Watch
debug = 0
numberOfQuakes = 9 # max of 20

command: "curl -s 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_week.geojson'"

refreshFrequency: '15m'

render: -> """
  <ul class="quakes cf">
  </ul>
  """

update: (output, domEl) ->
  #quakes = JSON.parse(output)
  quakeData = JSON.parse(output)
  
  ul = $(domEl).find('ul')

  ul.html ''

  renderQuake = (quake) ->
    """
    <li class="quake #{ quake.rowclass }">
      <div class="left">
        <div class="image" style="background-image: url(#{ quake.image });">#{ quake.mag }</div>
      </div>
      <div class="right">
        <div class="title">#{ quake.title }</div>
        <div class="date">#{ quake.date }</div>
      </div>
      </a>
    </li>
    """

  #for quake in quakes
    #ul.append renderQuake(quake)


  theQuake = ""
  if debug
    console.log(quakeData)
  # image

  if numberOfQuakes > 20
    maxQuakes = 20
  else
    maxQuakes = numberOfQuakes
  for i in [0..numberOfQuakes-1]

    magnatude = quakeData.features[i].properties.mag.toFixed 1
    location = quakeData.features[i].properties.place
    quakeTime = new Date(quakeData.features[i].properties.time)
    dayofweek = quakeTime.getDay()
    daylist = [
      'Sunday'
      'Monday'
      'Tuesday'
      'Wednesday '
      'Thursday'
      'Friday'
      'Saturday'
    ]
    month = quakeTime.getMonth()
    monthlist = [
      'January'
      'February'
      'March'
      'April'
      'May'
      'June'
      'July'
      'August'
      'September'
      'October'
      'November'
      'December'
    ]
    
    hour = quakeTime.getHours()
    minutes = quakeTime.getMinutes()
    seconds = quakeTime.getSeconds()
    meridian = if hour >= 12 then ' pm' else ' am'
    hour = if hour > 12 then hour - 12 else hour
    displayTime = hour
    if hour == 0 and meridian == ' PM '
      if minutes == 0 and seconds == 0
        displayTime = 'noon'
    if hour == 0 and meridian == ' AM '
      if minutes == 0 and seconds == 0
        displayTime= ' Midnight'
    if minutes < 10
        minutes = '0' + minutes 
    if seconds < 10
        seconds = '0' + seconds 
    displayQuakeTime = daylist[dayofweek] + ', ' + monthlist[month] + ' ' + quakeTime.getDate() + ' @ ' + displayTime + ':' + minutes + ':' + seconds + meridian

    magStyle = "small"
    if magnatude>=3 then magStyle = "m3"
    if magnatude>=4 then magStyle = "m4"
    if magnatude>=5 then magStyle = "m5"
    if magnatude>=6 then magStyle = "m6"
    if magnatude>=7 then magStyle = "m7"
    if magnatude>=8 then magStyle = "mega"

     
    quake =
      image: "quake-watch-2.widget/images/" + magStyle + ".png" 
      title: location
      date: displayQuakeTime
      mag: magnatude
      rowclass: magStyle

    ul.append renderQuake(quake)










style: """
  width: 100%
  top: 380px
  left: 1520px
  color: #000
  overflow: hidden
  max-width: 400px
  background: rgba(255, 255, 255, 0.2)
  border-radius: 5px
  color: white
  font-family: "American Typewriter", sans-serif
  -webkit-font-smoothing: antialiased

  a 
    color: inherit

  *
    box-sizing: border-box;
    margin: 0
    padding: 0

  .quake
    list-style: none
    float: left
    width: 100%
    height: auto
    display: inline-block
    padding: 10px
    border-bottom: 1px solid rgba(255, 255, 255, 0.3)

  .quake:last-child
    border-bottom: none

  .left, .right
    float: left
    height: 50px

  .left
    width: 20%

  .right
    width: 80%
    padding-top: 7px
    line-height: 1.2
    text-indent: 3px

  .cf:before,
  .cf:after
    content: " "; /* 1 */
    display: table; /* 2 */

  .cf:after
    clear: both

  .image
    width: 50px;
    height: 50px
    text-align: center;
    background-size: cover
    font-family: "OcrB"
    font-weight: bold
    color: #ff0
    font-size: 24px
    text-shadow: 2px 2px 4px #000000
  .date
    font-weight: 400
    font-size: 14px
    opacity: 0.8

  .title
    font-family: "American Typewriter"
    white-space: nowrap
    text-overflow: ellipsis
    overflow: hidden
  .magnatude
    font-family: "OcrB"
    font-weight: bold
    color: #ff0
  .small
    background-color: rgba(20, 20, 20, .9)
    color: #fff
  .m1
    background-color: rgba(0, 0, 0, .5)
    color: #000
  .m2
    background-color: rgba(0, 0, 0, .5)
    color: #777
  .m3
    background-color: rgba(0, 0, 0, .5)
    color: #fff
  .m4
    background-color: rgba(13, 13, 251, .4)
    color: #fff
  .m5
    background-color: rgba(255,220, 0, .4)
    color: #fff
  .m6
    background-color: rgba(251, 132, 13, .5)
    color: #fff
  .m7
    background-color: rgba(255, 0, 0, .5)
    color: #777
  .mega
    background-color: rgba(255, 0, 0, .5)
    color: #777

"""