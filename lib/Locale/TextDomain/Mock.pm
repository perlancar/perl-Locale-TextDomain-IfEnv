package Locale::TextDomain::Mock;

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

    my $caller = caller;
    for (qw(__ __x __n __nx __xn __p __px __np __npx
            N__ N__n N__p N__np)) {
        *{"$caller\::$_"} = \&{$_};
    }
}

1;
# ABSTRACT: Mock Locale::TextDomain functions

=for Pod::Coverage ^(.+)$
