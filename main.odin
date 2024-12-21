package main

import "gnuplot"
import "core:math"

main :: proc() {

	plot1 := gnuplot.make_plot( .Line_1d, "Waves 1", { "time (s)", "Amplitude" }, { "sin(wt)" } )
	plot2 := gnuplot.make_plot( .Line_2d, "Waves 2", { "time (s)", "Amplitude" }, { "sin(wt)", "sin(wt+pi/4)" } )
	plot3 := gnuplot.make_plot( .Line_3d, "Waves 3", { "time (s)", "Amplitude" }, { "sin(wt)", "sin(wt+pi/4)", "cos(wt)" } )
	plot4 := gnuplot.make_plot( .Line_4d, "Waves 4", { "time (s)", "Amplitude" }, { "sin(wt)", "sin(wt+pi/4)", "cos(wt)", "cos(wt+pi/4)" } )
	plot5 := gnuplot.make_plot( .Splot, "Ellipse", { "x", "y", "z" }, { "Trajectory" } )

	for i in 0 ..< 200 {

		data : [ 4 ]f64 = {
			math.sin( 2.0 * math.PI * 0.01 * f64( i ) ),
			math.sin( 2.0 * math.PI * 0.01 * f64( i ) + 0.25 * math.PI ),
			math.cos( 2.0 * math.PI * 0.01 * f64( i ) ),
			math.cos( 2.0 * math.PI * 0.01 * f64( i ) + 0.25 * math.PI ),
		}

		gnuplot.update_plot( &plot1, data[ 0:0 ] )
		gnuplot.update_plot( &plot2, data[ 0:1 ] )
		gnuplot.update_plot( &plot3, data[ 0:2 ] )
		gnuplot.update_plot( &plot4, data[ 0:3 ] )
		gnuplot.update_plot( &plot5, data[ 0:2 ] )
	}

	gnuplot.show_plot( plot1 )
	gnuplot.show_plot( plot2 )
	gnuplot.show_plot( plot3 )
	gnuplot.show_plot( plot4 )
	gnuplot.show_plot( plot5 )
}
