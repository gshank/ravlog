package CatalystX::Comments;
use Moose::Role;
use CatalystX::Comments::Form;
use CatalystX::Comments::BaseForm;

sub stash_comment_form {
    my( $self, $c, $article_id ) = @_;
    my $form;
    my $user;
    $user = $c->user if $c->can( 'user' );
    my $form_class;
    if( defined $user ){
        $form_class = 'CatalystX::Comments::BaseForm';
    }
    else{
        $form_class = 'CatalystX::Comments::Form';
    }
    $form = $form_class->new( 
        schema => $c->model( $self->model_name ),
    );
    if( $c->req->method eq 'POST' ){
        my $params = $c->req->params;
        $form->params( $params );
        if( $form->process ){
            my $comment = $form->item;
            my @user_param = ();
            @user_param = ( user_id => $user->id ) if defined $user;
            $comment->update( { article_id => $article_id, remote_ip => $c->req->address, @user_param } );
            $c->res->redirect( $c->uri_for($c->action, $c->req->captures) );
        }
    }
    $c->stash( comment_form => $form );
}

no Moose::Role;
1;

