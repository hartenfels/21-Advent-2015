unit class IntVec is repr('CPointer');
use NativeCall;

sub intvec_new(--> IntVec) is native('intvec') { ... }
multi method new() { intvec_new() }

sub intvec_free(IntVec) is native('intvec') { ... }
method DESTROY { intvec_free(self) }

sub intvec_push(IntVec, int32) is native('intvec') { ... }
method push($x) { intvec_push(self, $x) }

sub intvec_at(IntVec, int32 --> int32) is native('intvec') { ... }
method AT-POS($i) { intvec_at(self, $i) }
