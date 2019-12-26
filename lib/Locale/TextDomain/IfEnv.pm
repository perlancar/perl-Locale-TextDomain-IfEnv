package Locale::TextDomain::IfEnv;

# AUTHORITY
# DATE
# DIST
# VERSION

#use strict 'subs', 'vars';
#use warnings;

sub __expand($@) {
    my ($translation, %args) = @_;
    my $re = join '|', map { quotemeta $_ } keys %args;
    $translation =~ s/\{($re)\}/defined $args{$1} ? $args{$1} : "{$1}"/ge;
    $translation;
}

# plain string
sub __($) {
    $_[0];
}

# interpolation
sub __x($@) {
    goto &__expand;
}

# plural
sub __n($$$) {
    my ($msgid, $msgid_plural, $count) = @_;
    $count > 1 ? $msgid_plural : $msgid;
}

# plural + interpolation
sub __nx($$$@) {
    my ($msgid, $msgid_plural, $count, %args) = @_;
    __expand($count > 1 ? $msgid_plural : $msgid, %args);
}

# alias for __nx
sub __xn($$$@) {
    goto &__nx;
}

# context
sub __p($$) {
    $_[1];
}

# context + interpolation
sub __px($$@) {
    my $context = shift;
    goto &__x;
}

# context + plural
sub __np($$$$) {
    my $context = shift;
    goto &__n;
}

# context + plural + interpolation
sub __npx($$$$@) {
    my $context = shift;
    goto &__nx;
}

# Dummy functions for string marking.
sub N__($) {
    return shift;
}

sub N__n($$$) {
    return @_;
}

sub N__p($$) {
    return @_;
}

sub N__np($$$$) {
    return @_;
}

sub import {
    my $class = shift;
    local $Locale::TextDomain::IfEnv::textdomain = shift;
    local @Locale::TextDomain::IfEnv::search_dirs = @_;

    my $caller = caller;

    if ($ENV{PERL_LOCALE_TEXTDOMAIN_IFENV}) {
        require Locale::TextDomain;
        eval "package $caller; use Locale::TextDomain \$Locale::TextDomain::IfEnv::textdomain, \@Locale::TextDomain::IfEnv::search_dirs;";
        die if $@;
    } else {
        for (qw(__ __x __n __nx __xn __p __px __np __npx
                N__ N__n N__p N__np)) {
            *{"$caller\::$_"} = \&{$_};
        }
    }
}

1;
# ABSTRACT: Enable translation only when environment variable flag is true

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

Use like you would use L<Locale::TextDomain> (but see L</Caveats>):

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

=head2 Caveats

For simplicity, currently the tied hash (C<%__>) and its hashref (C<$__>) are
not provided. Contact me if you use and need this.


=head1 ENVIRONMENT


=head1 SEE ALSO

L<Locale::TextDomain>

L<Locale::TextDomain::UTF8::IfEnv>

L<Bencher::Scenario::LocaleTextDomainIfEnv>

=cut
