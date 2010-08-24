use Modern::Perl;
use Test::More;

use CSS::Prepare;
use Data::Dumper;
local $Data::Dumper::Terse     = 1;
local $Data::Dumper::Indent    = 1;
local $Data::Dumper::Useqq     = 1;
local $Data::Dumper::Deparse   = 1;
local $Data::Dumper::Quotekeys = 0;
local $Data::Dumper::Sortkeys  = 1;

if ( $ENV{'OFFLINE'} ) {
    plan skip_all => 'Not online.';
    exit;
}
plan tests => 2;

my $preparer = CSS::Prepare->new();
my( @structure, $output, $css );

if ( ! $preparer->has_http() ) {
    ok( 1 == 0, 'HTTP::Lite or LWP::UserAgent not found' );
}


{
    $css = <<CSS;
body{text-align:center;}
#doc,#doc2,#doc3,#doc4,.yui-t1,.yui-t2,.yui-t3,.yui-t4,.yui-t5,.yui-t6,.yui-t7{margin:auto;width:57.69em;text-align:left;*width:56.25em;}
#doc2{width:73.076em;*width:71.25em;}
#doc3{margin:auto 10px;width:auto;}
#doc4{width:74.923em;*width:73.05em;}
.yui-b{position:relative;}
.yui-b{_position:static;}
#yui-main .yui-b{position:static;}
#yui-main,.yui-g .yui-u .yui-g{width:100%;}
.yui-t1 #yui-main,.yui-t2 #yui-main,.yui-t3 #yui-main{float:right;margin-left:-25em;}
.yui-t4 #yui-main,.yui-t5 #yui-main,.yui-t6 #yui-main{float:left;margin-right:-25em;}
.yui-t1 .yui-b{float:left;width:12.30769em;*width:12.00em;}
.yui-t1 #yui-main .yui-b{margin-left:13.30769em;*margin-left:13.05em;}
.yui-t2 .yui-b{float:left;width:13.8461em;*width:13.50em;}
.yui-t2 #yui-main .yui-b{margin-left:14.8461em;*margin-left:14.55em;}
.yui-t3 .yui-b{float:left;width:23.0769em;*width:22.50em;}
.yui-t3 #yui-main .yui-b{margin-left:24.0769em;*margin-left:23.62em;}
.yui-t4 .yui-b{float:right;width:13.8456em;*width:13.50em;}
.yui-t4 #yui-main .yui-b{margin-right:14.8456em;*margin-right:14.55em;}
.yui-t5 .yui-b{float:right;width:18.4615em;*width:18.00em;}
.yui-t5 #yui-main .yui-b{margin-right:19.4615em;*margin-right:19.125em;}
.yui-t6 .yui-b{float:right;width:23.0769em;*width:22.50em;}
.yui-t6 #yui-main .yui-b{margin-right:24.0769em;*margin-right:23.62em;}
.yui-t7 #yui-main .yui-b{display:block;margin:0 0 1em;}
#yui-main .yui-b{float:none;width:auto;}
.yui-g .yui-gb .yui-u,.yui-gb .yui-g,.yui-gb .yui-gb,.yui-gb .yui-gc,.yui-gb .yui-gd,.yui-gb .yui-ge,.yui-gb .yui-gf,.yui-gb .yui-u,.yui-gc .yui-g,.yui-gc .yui-u,.yui-gd .yui-u{float:left;}
.yui-g .yui-g,.yui-g .yui-gb,.yui-g .yui-gc,.yui-g .yui-gc .yui-u,.yui-g .yui-gd,.yui-g .yui-ge,.yui-g .yui-gf,.yui-g .yui-u,.yui-gc .yui-u,.yui-gd .yui-g,.yui-ge .yui-g,.yui-ge .yui-u,.yui-gf .yui-g,.yui-gf .yui-u{float:right;}
.yui-g .yui-gc div.first,.yui-g .yui-ge div.first,.yui-g div.first,.yui-gb div.first,.yui-gc div.first,.yui-gc div.first div.first,.yui-gd div.first,.yui-ge div.first,.yui-gf div.first{float:left;}
.yui-g .yui-g,.yui-g .yui-gb,.yui-g .yui-gc,.yui-g .yui-gd,.yui-g .yui-ge,.yui-g .yui-gf,.yui-g .yui-u{width:49.1%;}
.yui-g .yui-gb .yui-u,.yui-gb .yui-g,.yui-gb .yui-gb,.yui-gb .yui-gc,.yui-gb .yui-gd,.yui-gb .yui-ge,.yui-gb .yui-gf,.yui-gb .yui-u,.yui-gc .yui-g,.yui-gc .yui-u,.yui-gd .yui-u{width:32%;margin-left:1.99%;}
.yui-gb .yui-u{*width:31.9%;*margin-left:1.9%;}
.yui-gc div.first,.yui-gd .yui-u{width:66%;}
.yui-gd div.first{width:32%;}
.yui-ge div.first,.yui-gf .yui-u{width:74.2%;}
.yui-ge .yui-u,.yui-gf div.first{width:24%;}
.yui-g .yui-gb div.first,.yui-gb div.first,.yui-gc div.first,.yui-gd div.first{margin-left:0;}
.yui-g .yui-g .yui-u,.yui-gb .yui-g .yui-u,.yui-gc .yui-g .yui-u,.yui-gd .yui-g .yui-u,.yui-ge .yui-g .yui-u,.yui-gf .yui-g .yui-u{width:49%;*width:48.1%;*margin-left:0;}
.yui-g .yui-g .yui-u{width:48.1%;}
.yui-g .yui-gb div.first,.yui-gb .yui-gb div.first{*width:32%;_width:31.7%;*margin-right:0;}
.yui-g .yui-gc div.first,.yui-gd .yui-g{width:66%;}
.yui-gb .yui-g div.first{*margin-right:4%;_margin-right:1.3%;}
.yui-gb .yui-gc div.first,.yui-gb .yui-gd div.first{*margin-right:0;}
.yui-gb .yui-gb .yui-u,.yui-gb .yui-gc .yui-u{*margin-left:1.8%;_margin-left:4%;}
.yui-g .yui-gb .yui-u{_margin-left:1.0%;}
.yui-gb .yui-gd .yui-u{*width:66%;_width:61.2%;}
.yui-gb .yui-gd div.first{*width:31%;_width:29.5%;}
.yui-g .yui-gc .yui-u,.yui-gb .yui-gc .yui-u{width:32%;margin-right:0;_float:right;_margin-left:0;}
.yui-gb .yui-gc div.first{width:66%;*float:left;*margin-left:0;}
.yui-gb .yui-ge .yui-u,.yui-gb .yui-gf .yui-u{margin:0;}
.yui-gb .yui-gb .yui-u{_margin-left:.7%;}
.yui-gb .yui-g div.first,.yui-gb .yui-gb div.first{*margin-left:0;}
.yui-gc .yui-g .yui-u,.yui-gd .yui-g .yui-u{*width:48.1%;*margin-left:0;}
.yui-gb .yui-gd div.first{width:32%;}
.yui-g .yui-gd div.first{_width:29.9%;}
.yui-ge .yui-g{width:24%;}
.yui-gf .yui-g{width:74.2%;}
.yui-gb .yui-ge div.yui-u,.yui-gb .yui-gf div.yui-u{float:right;}
.yui-gb .yui-ge div.first,.yui-gb .yui-gf div.first{float:left;}
.yui-gb .yui-ge .yui-u,.yui-gb .yui-gf div.first{*width:24%;_width:20%;}
.yui-gb .yui-ge div.first,.yui-gb .yui-gf .yui-u{*width:73.5%;_width:65.5%;}
.yui-ge div.first .yui-gd .yui-u{width:65%;}
.yui-ge div.first .yui-gd div.first{width:32%;}
#bd:after,#ft:after,#hd:after,.yui-g:after,.yui-gb:after,.yui-gc:after,.yui-gd:after,.yui-ge:after,.yui-gf:after{clear:both;content:".";display:block;height:0;visibility:hidden;}
CSS

    @structure = $preparer->parse_url(
                     'http://yui.yahooapis.com/2.8.0r4/build/grids/grids.css'
                 );
    
    my @errors = (
            { error => q(invalid property: 'zoom') },
        );
    my @found_errors;
    foreach my $block ( @structure ) {
        foreach my $error ( @{$block->{'errors'}} ) {
            push @found_errors, @{$block->{'errors'}};
        }
    }
    is_deeply( \@errors, \@found_errors )
        or say "YUI grids 2.8.0r4 errors was:\n" . Dumper \@errors;
    
    $output = $preparer->output_as_string( @structure );
    ok( $output eq $css )
        or say "YUI grids 2.8.0r4 was:\n" . $output;
}
