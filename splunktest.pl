#!/usr/bin/perl
# =============================================================================
# Declare commonly used things
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
# Print the original arguments
# =============================================================================
sub DumpOriginalArguments()
{
  	Vprint ("The original argument 0=\"".$ARGV[0]."\"\n");
  	Vprint ("The original argument 1=\"".$ARGV[1]."\"\n");
  	Vprint ("The original argument 2=\"".$ARGV[2]."\"\n");
  	Vprint ("The original argument 3=\"".$ARGV[3]."\"\n");
  	Vprint ("The original argument 4=\"".$ARGV[4]."\"\n");
  	Vprint ("The original argument 5=\"".$ARGV[5]."\"\n");
  	Vprint ("The original argument 6=\"".$ARGV[6]."\"\n");
  	Vprint ("The original argument 7=\"".$ARGV[7]."\"\n");
  	Vprint ("The original argument 8=\"".$ARGV[8]."\"\n");
  	Vprint ("The original argument 9=\"".$ARGV[9]."\"\n");
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
		print "This Perl script checks to see if there are splunk machine names in a file.\n";
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
# ==============================================================================
# Machine name search
# ==============================================================================
sub are_there_any_machine_names($$)
{
	my $theFile=shift;
	my $printNames=shift;
	my $were_there_codes=0;
	Vprint ("The file to check is=\"".$theFile."\"\n");
	if(!open (SPLUNK_FILE, "<".$theFile ))
	{
		print "Could not open the file:".$theFile;
		exit 1;
	}
	else
	{
		while (<SPLUNK_FILE>)
		{
			chomp;
			if (/splunk-[a-zA-Z]+-[0-9]+/)
			{
				my $machineID=$_;
				#$machineID =~ s/^.*splunk-//; TOO GREEDY
				$machineID =~ s/[^splunk-]*//;
				$machineID =~ s/splunk-//;
				print $machineID."\n";
				if ($printNames)
				{
					if (/^splunk-[a-zA-Z]+-[0-9]+$/)
					{
						print "The line \"".$_."\" is a splunk machine name.\n";
					}
					elsif (/\s*splunk-[a-zA-Z]+-[0-9]+\s*/)
					{
						print "The line \"".$_."\" is a splunk machine name with white space.\n";
					}
					else
					{
						print "The line \"".$_."\" contains a splunk machine name.\n";
					}
					
					
				}
				$were_there_codes=1;
			}
			else
			{
				if (!$printNames)
				{
					print "The line \"".$_."\" does not contain a splunk machine name.\n";
				}
			}
			#if (/splunk-[a-zA-Z]+-[0-9]+/)
			#{
			#	print "The line \"".$_."\" matches extra check\n";
			#}
		}
		close(SPLUNK_FILE)
		
	}
	return $were_there_codes;
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
	print "Checking for machine names in the file $ARGV[0]:\n\n";
	if (are_there_any_machine_names($ARGV[0],0))
	{
		print "\n\nHere are the machine names:\n\n";
		are_there_any_machine_names($ARGV[0],1);
		print "\n\nThere are machine codes in this file!\n";
	}
	else
	{
		print "\n\nThere are no machine codes in this file!\n";
	}
	# If there was an error the exit with ErrorExitAndLog...
	if ($ThereWasAnError)
	{
		ErrorExitAndLog ("An unknown error occurred");
	}
}
main();
exit 0;
__END__