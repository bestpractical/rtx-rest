package RT::Extension::REST2::Resource::Record::Hypermedia;
use strict;
use warnings;

use Moose::Role;
use namespace::autoclean;
use RT::Extension::REST2::Util qw(query_string);
use JSON qw(to_json);

sub hypermedia_links {
    my $self = shift;
    return [ $self->_self_link ];
}

sub _self_link {
    my $self = shift;
    my $record = $self->record;

    my $class = blessed($record);
    $class =~ s/^RT:://;
    $class = lc $class;
    my $id = $record->id;

    return {
        ref     => 'self',
        type    => $class,
        id      => $id,
        _url    => RT::Extension::REST2->base_uri . "/$class/$id",
    };
}

sub _transaction_history_link {
    my $self = shift;
    my $record = $self->record;

    my $query = query_string(query => to_json [
        { field => 'ObjectType', value => blessed($record) },
        { field => 'ObjectId', value => $record->Id },
    ]);

    return {
        ref     => 'history',
        _url    => RT::Extension::REST2->base_uri . "/transactions?$query",
    };
}

1;
