package Locale::TextDomain::IfEnv;

# AUTHORITY
# DATE
# DIST
# VERSION

#use strict 'subs', 'vars';
#use warnings;

sub __ { $_[0] }

sub import {
    my ($class, @imports) = @_;

    if ($ENV{PERL_LOCALE_TEXTDOMAIN_IFENV}) {
        require Locale::TextDomain;
        Locale::TextDomain->import(@_);
    } else {
        my $caller = caller;
        *{"$caller\::__"} = \&__;
    }
}

1;
# ABSTRACT: Enable translation only when environment variable flag is true

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

Use like you would use L<Locale::TextDomain>:

 use Locale::TextDomain::IfEnv 'Some-TextDomain';

 print __ "Hello, world!\n";


=head1 DESCRIPTION

When imported, Locale::TextDomain::IfEnv will check the
C<PERL_LOCALE_TEXTDOMAIN_IFENV> environment variable. If the environment
variable has a true value, the module will load L<Locale::TextDomain> and pass
the import arguments to it. If the environment variable is false, the module
will install a mock version of C<__>, et al. Thus, all strings will translate to
themselves.

This module can be used to avoid the startup (and runtime) cost of translation
unless when you want to enable translation.


=head1 ENVIRONMENT


=head1 SEE ALSO

L<Locale::TextDomain>

L<Locale::TextDomain::UTF8::IfEnv>

L<Bencher::Scenario::LocaleTextDomainIfEnv>

=cut
