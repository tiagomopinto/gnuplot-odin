package gnuplot

import "core:os/os2"
import "core:sys/posix"
import "core:fmt"

Plot_type :: enum {

	Line_1d,
	Line_2d,
	Line_3d,
	Line_4d,
	Splot,
}

Plot :: struct {

	pipe : ^posix.FILE,
	type: Plot_type,
	data_len : int,
}

make_plot :: proc (
	type: Plot_type,
	title : cstring,
	axes_labels: []cstring,
	data_labels: []cstring,
) -> (
	plot: Plot,
) {

	plot.pipe = posix.popen( "gnuplot", "w" )

	if plot.pipe == nil {

		fmt.println( "Error creating gnuplot pipe!" )

		os2.exit( 1 )
	}

	plot.type = type

	title_font_size := 13
	labels_font_size := 10

	posix.fprintf( plot.pipe, "set terminal qt title 'Odin Plot'\n")
	posix.fprintf( plot.pipe, "set title  '%s' font ',%d' \n", title, title_font_size )
	posix.fprintf( plot.pipe, "set grid \n" )
	posix.fprintf( plot.pipe, "set key autotitle columnhead \n" )
	posix.fprintf( plot.pipe, "set style data lines \n" )

	switch type {

	case .Line_1d :
		posix.fprintf( plot.pipe, "set xlabel '%s' font ',%d' \n", axes_labels[ 0 ], labels_font_size )
		posix.fprintf( plot.pipe, "set ylabel '%s' font ',%d' \n", axes_labels[ 1 ], labels_font_size )
		posix.fprintf( plot.pipe, "$data << EOD \n" )
		posix.fprintf( plot.pipe, "t %s \n", data_labels[ 0 ] )
	case .Line_2d :
		posix.fprintf( plot.pipe, "set xlabel '%s' font ',%d' \n", axes_labels[ 0 ], labels_font_size )
		posix.fprintf( plot.pipe, "set ylabel '%s' font ',%d' \n", axes_labels[ 1 ], labels_font_size )
		posix.fprintf( plot.pipe, "$data << EOD \n" )
		posix.fprintf( plot.pipe, "t %s %s \n", data_labels[ 0 ], data_labels[ 1 ] )
	case .Line_3d :
		posix.fprintf( plot.pipe, "set xlabel '%s' font ',%d' \n", axes_labels[ 0 ], labels_font_size )
		posix.fprintf( plot.pipe, "set ylabel '%s' font ',%d' \n", axes_labels[ 1 ], labels_font_size )
		posix.fprintf( plot.pipe, "$data << EOD \n" )
		posix.fprintf( plot.pipe, "t %s %s %s \n", data_labels[ 0 ], data_labels[ 1 ], data_labels[ 2 ] )
	case .Line_4d :
		posix.fprintf( plot.pipe, "set xlabel '%s' font ',%d' \n", axes_labels[ 0 ], labels_font_size )
		posix.fprintf( plot.pipe, "set ylabel '%s' font ',%d' \n", axes_labels[ 1 ], labels_font_size )
		posix.fprintf( plot.pipe, "$data << EOD \n" )
		posix.fprintf( plot.pipe, "t %s %s %s %s \n", data_labels[ 0 ], data_labels[ 1 ], data_labels[ 2 ], data_labels[ 3 ] )
	case .Splot :
		posix.fprintf( plot.pipe, "set xlabel '%s' font ',%d' \n", axes_labels[ 0 ], labels_font_size )
		posix.fprintf( plot.pipe, "set ylabel '%s' font ',%d' \n", axes_labels[ 1 ], labels_font_size )
		posix.fprintf( plot.pipe, "set zlabel '%s' font ',%d' \n", axes_labels[ 2 ], labels_font_size )
		posix.fprintf( plot.pipe, "$data << EOD \n" )
		posix.fprintf( plot.pipe, "%s \n", data_labels[ 0 ] )
	}

	return plot
}

update_plot :: proc ( plot: ^Plot, data: []f64 ) {

	switch plot.type {

	case .Line_1d :
		posix.fprintf( plot.pipe, "%d  %.4lf \n", plot.data_len, data[ 0 ] )
	case .Line_2d :
		posix.fprintf( plot.pipe, "%d  %.4lf  %.4lf \n", plot.data_len, data[ 0 ], data[ 1 ] )
	case .Line_3d :
		posix.fprintf( plot.pipe, "%d  %.4lf  %.4lf  %.4lf \n", plot.data_len, data[ 0 ], data[ 1 ], data[ 2 ] )
	case .Line_4d :
		posix.fprintf( plot.pipe, "%d  %.4lf  %.4lf  %.4lf  %.4lf \n", plot.data_len, data[ 0 ], data[ 1 ], data[ 2 ], data[ 3 ] )
	case .Splot :
		posix.fprintf( plot.pipe, "%.4lf  %.4lf  %.4lf \n", plot.data_len, data[ 0 ], data[ 1 ], data[ 2 ] )
	}

	plot.data_len += 1
}

show_plot :: proc ( plot: Plot ) {

	posix.fprintf( plot.pipe, "EOD \n" )

	switch plot.type {

	case .Line_1d :
		posix.fprintf( plot.pipe, "plot $data using 1:2 \n" )
	case .Line_2d :
		posix.fprintf( plot.pipe, "plot $data using 1:2, $data using 1:3 \n" )
	case .Line_3d :
		posix.fprintf( plot.pipe, "plot $data using 1:2, $data using 1:3, $data using 1:4 \n" )
	case .Line_4d :
		posix.fprintf( plot.pipe, "plot $data using 1:2, $data using 1:3, $data using 1:4, $data using 1:5\n" )
	case .Splot :
		posix.fprintf( plot.pipe, "splot $data \n" )
	}

	posix.fprintf( plot.pipe, "pause mouse close \n" )

	posix.fflush( plot.pipe )
}
