# Monty-Tuning

Monty-Tuning &nbsp;is the "tuned/maked" version of the original Monty robot I made in 2002.<br />
<br />
<table cellpadding="0" cellspacing="0" class="tr-caption-container" style="float: right; text-align: right;"><tbody>
<tr><td style="text-align: center;"><a href="http://1.bp.blogspot.com/-ZPzoRPkNqI0/Uu4v1zP4fSI/AAAAAAAAJhc/sIJxSrqB9UY/s1600/montun1.jpg" style="clear: right; margin-bottom: 1em; margin-left: auto; margin-right: auto;"><img border="0" height="320" src="http://1.bp.blogspot.com/-ZPzoRPkNqI0/Uu4v1zP4fSI/AAAAAAAAJhc/sIJxSrqB9UY/s1600/montun1.jpg" width="232" /></a></td></tr>
<tr><td class="tr-caption" style="text-align: center;">Monty-Tuning robot</td></tr>
</tbody></table>
It is a robot that moves by means of a wheels differential traction and has many sensors and actuators:<br />
<br />
<ul>
<li>Two motors for traction,</li>
<li>A motor for the clamp of the arm,</li>
<li>Ultrasounds sensor for the detection of movement,</li>
<li>Two sensors of light in the head for the location of light sources,</li>
<li>Sensors of infrared reflection in the base for pursuit of black lines,</li>
<li>Microphone,&nbsp;</li>
<li>Loudspeaker and&nbsp;</li>
<li>Bumpers for the detection of obstacles.</li>
</ul>
<br />
The set is governed by a microcontroller PIC-16F84 and another small microcontroller (PIC-12C50A) preprogrammed for the management of the movements of the clamp.<br />
<br />
<div class="separator" style="clear: both; text-align: center;">
<object class="BLOGGER-youtube-video" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0" data-thumbnail-src="https://ytimg.googleusercontent.com/vi/sxKUdWXSZJE/0.jpg" height="266" width="320"><param name="movie" value="https://www.youtube.com/v/sxKUdWXSZJE?version=3&amp;f=user_uploads&amp;c=google-webdrive-0&amp;app=youtube_gdata" /><param name="bgcolor" value="#FFFFFF" /><param name="allowFullScreen" value="true" /><embed allowfullscreen="true" height="266" src="https://www.youtube.com/v/sxKUdWXSZJE?version=3&amp;f=user_uploads&amp;c=google-webdrive-0&amp;app=youtube_gdata" type="application/x-shockwave-flash" width="320"></embed></object></div>
<br />
The circuitry is composed by five cards:<br />
<br />
<div class="separator" style="clear: both; text-align: center;">
<a href="http://4.bp.blogspot.com/-JHiVnIE2kVY/Uu4xOeQlnII/AAAAAAAAJho/dMPzyKwn3UU/s1600/montun2.jpg" style="clear: left; float: left; margin-bottom: 1em; margin-right: 1em;"><img border="0" height="320" src="http://4.bp.blogspot.com/-JHiVnIE2kVY/Uu4xOeQlnII/AAAAAAAAJho/dMPzyKwn3UU/s1600/montun2.jpg" width="192" /></a></div>
<b>Card for Control</b>: It contains the logic of the micro, the interface with the PC for the programming of the micro and the power regulation unit.<br />
<br />
<b>Card for Power and I/O</b>: It contains the H-bridges that feed the traction motors and the digital I/O &nbsp;for the digital sensors. The input signals are prepared at good TTL levels and sent to the microcontroller (Plate of Control) through a flat cable<br />
<br />
<b>Card for Management of the arm</b>: It contains the small preprogrammed microcontroller and the required H-bridge to govern the movements of the clamp<br />
<br />
<b>Card for light sensors</b>: It adapts the analogical input from the sensors of light of the head for the detection of a threshold that allows to specify what sensor receives more light.<br />
<br />
<b>Card for Sensors and actuators</b>: It contains the necessary electronics for the control and adaptation of the signal of the other sensors and analogical actuators (ultrasounds, microphone and loudspeaker).<br />
<br />
<div class="separator" style="clear: both; text-align: center;">
<a href="http://3.bp.blogspot.com/-29u2c13Bk58/Uu4xUucQ_VI/AAAAAAAAJhw/N8k9WiMGFMk/s1600/montun3.jpg" style="clear: right; float: right; margin-bottom: 1em; margin-left: 1em;"><img border="0" height="292" src="http://3.bp.blogspot.com/-29u2c13Bk58/Uu4xUucQ_VI/AAAAAAAAJhw/N8k9WiMGFMk/s1600/montun3.jpg" width="320" /></a></div>
The robot has been programmed to stay quiet until it hears a strong noise (like for example an applause). Then "it wakes up" and it tries to go towards illuminated zones. If it does not detect light it turns on &nbsp;in an attempt to find light around. If the attempt fails it returns the the "sleep mode" until hearing a new noise. In his way of search and pursuit of the light it will be detecting the obstacles and applying algorithms to avoid them.<br />
<br />
The programming has been made in assembler. The code is widely commented for their understanding (but unfortunately in Spanish by now).<br />
<br />
At the beginning of the program it is indicated to what I/O ports &nbsp;the sensors/actuators are connected.<br />
<br />
