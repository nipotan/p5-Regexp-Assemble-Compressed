package Regexp::Assemble::Compressed;

use strict;
use warnings;
our $VERSION = '0.01';
use base qw(Regexp::Assemble);

sub as_string {
    my $self = shift;
    my $string = $self->SUPER::as_string;
    $string =~ s{(?<!\\)\[(.+?)(?<!\\)\]}{ "[" . _compress($1) . "]" }eg;
    return $string;
}

sub _compress {
    my $string = shift;
    my @characters = sort split //, $string;
    my @stack = ();
    my @skipped = ();
    my $last;
    for my $char (@characters) {
        my $num = ord $char;
        if ($last && $num - $last == 1) {
            push @skipped, $char;
            $last = $num;
            next;
        }
        elsif (@skipped) {
            push @stack, @skipped < 2 ? @skipped : ('-', $skipped[-1]);
            @skipped = ();
        }
        push @stack, $char;
        $last = $num;
    }
    if (@skipped) {
        push @stack, @skipped < 2 ? @skipped : ('-', $skipped[-1]);
    }
    return join '', @stack;
}

1;
__END__

=head1 NAME

Regexp::Assemble::Compressed - Assemble more compressed Regular Expression

=head1 SYNOPSIS

 use Regexp::Assemble::Compressed;
  
 my $ra = Regexp::Assemble::Compressed->new;
 my @cctlds = qw(ma mc md me mf mg mh mk ml mm mn mo mp
                 mq mr ms mt mu mv mw mx my mz);
 for my $tld ( @cctlds ) {
     $ra->add( $tld );
 }
 print $ra->re; # prints m[ac-hk-z].
                # Regexp::Assemble prints m[acdefghklmnopqrstuvwxyz]

=head1 DESCRIPTION

Regexp::Assemble::Compressed is a subclass of Regexp::Assemble.
It assembles more compressed regular expressions.

=head1 AUTHOR

Koichi Taniguchi E<lt>taniguchi@livedoor.jpE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Regexp::Assemble>

=cut
