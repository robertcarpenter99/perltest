#!/usr/bin/perl
# =============================================================================
# Declare commonl used things
# =============================================================================
use strict;  
use Getopt::Std;
use Cwd;
# =============================================================================
# Globals
# =============================================================================
my
(
	@FileList,
	$ThereWasAnError # Always keep this one
);
# =============================================================================
# Options
# =============================================================================
our
(
	$opt_V, # Verbose mode
	$opt_C, # Check only (no actions) and Verbose mode
	$opt_U, # Print usage and exit
);
# =============================================================================
# Print the original arguments (decrease args allowed to 6)
# =============================================================================
sub DumpOriginalArguments()
{
  	Vprint ("The original argument 0=\"".@ARGV[0]."\"\n");
  	Vprint ("The original argument 1=\"".@ARGV[1]."\"\n");
  	Vprint ("The original argument 2=\"".@ARGV[2]."\"\n");
  	Vprint ("The original argument 3=\"".@ARGV[3]."\"\n");
  	Vprint ("The original argument 4=\"".@ARGV[4]."\"\n");
  	Vprint ("The original argument 5=\"".@ARGV[5]."\"\n");
}
# =============================================================================
# Error handling
# =============================================================================
sub ErrorExitAndLog ($)
{
	my $LogStatement = shift @_;
	my $TheCurrentTime;
	if(!open (LOG_FILE, ">>exit.log" ))
	{
		print "Could not open the log file.";
		exit 1;
	}
	print LOG_FILE $LogStatement;
	print $LogStatement;
	$TheCurrentTime=localtime;
	print LOG_FILE "\nexited with this error on ".$TheCurrentTime."\n";
	print "\nexited with this error on ".$TheCurrentTime."\n";
	close (LOG_FILE);
	exit 1;
}
# ==============================================================================
# Print the usage and quite if usage was requested
# ==============================================================================
sub usage()
{
	if ($opt_U)
	{
		print "Usage:\n";
		print "	[-V] [-C] [-U]\n";
		print "	-V Verbose\n";
		print "	-C Check arguments and make no changes (implies -V)\n";
		print "	-U Usage\n";
		print "\n";
		exit 1;
	}
}
# ==============================================================================
# Print a line if the verbose flag is set
# ==============================================================================
sub Vprint($)
{
	my $printline = shift;
	
	if ($opt_V)
	{
		print "Verbose output: ";
		print $printline;
	}
}
# ==============================================================================
# Option checking
# ==============================================================================
sub verify_options()
{
	# Display the option settings
	if ($opt_V) { Vprint("Option V is set\n"); } else { Vprint("Option V is not set\n"); }
	if ($opt_C) { Vprint("Option C is set\n"); } else { Vprint("Option C is not set\n"); }
	if ($opt_U) { Vprint("Option U is set\n"); } else { Vprint("Option U is not set\n"); }
	# Display command line implications
	Vprint ("ThereWasAnError                =[$ThereWasAnError]\n");
	
}
# =============================================================================
# Start here
# =============================================================================
sub main()
{
	# Global to keep track of errors over the lenght of the run
	$ThereWasAnError=0;
	getopts('VCU');
	# Process the options
	if ($opt_C) { $opt_V=1; }
	DumpOriginalArguments();
	verify_options();
	usage();
	# Check command and options here
	if ($opt_C)
	{
		print "Only ran checks - Done!\n";
		exit 0;
	}
	# If there was an error do not run the commands
	if ($ThereWasAnError)
	{
		ErrorExitAndLog ("An unknown error occurred");
	}
	# Run the commands here
	@FileList=`dir/b/a:-d/o:n`;
	Vprint($FileList[0]);
	Vprint($FileList[1]);
	Vprint($FileList[2]);
	`sleep 3`;
	print "After after sleep\n";
	# If there was an error the exit with ErrorExitAndLog...
	if ($ThereWasAnError)
	{
		ErrorExitAndLog ("An unknown error occurred");
	}
}
main();
exit 0;
__END__
