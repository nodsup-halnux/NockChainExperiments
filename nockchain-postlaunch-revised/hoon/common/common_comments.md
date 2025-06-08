Finding all comments in files, for directory ./nockchain-postlaunch-revised/hoon/common

## stark/prover.hoon
- Line 6: ::TODO shouldn't need all of this but its useful to keep here for now
- Line 7: ::while we're figuring out how to turn all tables off or on in general

- Line 18: ::  +prove: prove the Nock computation [s f]
- Line 21: ::    .override: an optional list of which tables should be computed and constraints
- Line 22: ::    checked. this is for debugging use only, it should always be ~ in production.
- Line 23: ::    to use it for debugging, pass in the same list of tables to both +prove
- Line 24: ::    and +verify. these are the tables that will be computed - all others will
- Line 25: ::    be ignored. you do not need to worry about sorting it in the correct order, that
- Line 26: ::    happens automatically.

- Line 39: :: generate-proof is the main body of the prover.



## stark/verifier.hoon

- Line 9: ::  copied from sur/verifier.hoon because of =>  stark-engine







- Line 855: ::  verify a list of merkle proofs in a random order. This is to guard against DDOS attacks.

## pow.hoon

- Line 14: ::  +prove-block-inner

## slip10.hoon
- Line 1: ::  slip-10 implementation in hoon using the cheetah curve
- Line 3: ::  to use, call one of the core initialization arms.
- Line 4: ::  using the produced core, derive as needed and take out the data you want.
- Line 6: ::  NOTE:  tested to be correct against the SLIP-10 spec
- Line 7: ::   https://github.com/satoshilabs/slips/blob/master/slip-0010.md

- Line 15: ::  prv:  private key
- Line 16: ::  pub:  public key
- Line 17: ::  cad:  chain code
- Line 18: ::  dep:  depth in chain
- Line 19: ::  ind:  index at depth
- Line 20: ::  pif:  parent fingerprint (4 bytes)


- Line 29: ::  elliptic curve operations and values




- Line 40: ::  rendering



- Line 53: ::  core initialization



- Line 83: ::  derivation arms: Only used for testing.
- Line 85: ::    +derive-path
- Line 87: ::  Given a bip32-style path, i.e "m/0'/25", derive the key associated
- Line 88: ::  with that path.

- Line 95: ::    +derivation-path
- Line 97: ::  Parses the bip32-style derivation path and return a list of indices

- Line 111: ::    +derive-sequence
- Line 113: ::  Derives a key from a list of indices associated with a bip32-style path.

- Line 121: ::    +derive
- Line 123: ::  Checks if prv has been set to 0, denoting a wallet which only
- Line 124: ::  contains public keys. If prv=0, call derive-public otherwise
- Line 125: ::  call derive-private.

- Line 132: ::    +derive-private
- Line 134: ::  derives the i-th child key from `prv`

- Line 178: ::    +derive-public
- Line 180: ::  derives the i-th child key from `pub`

## bip39-english.hoon
- Line 1: ::  english wordlist for use in bip39

## ztd/five.hoon
- Line 4: ::    utils


- Line 42: ::  triple belt

- Line 48: ::  raise belt


## ztd/eight.hoon
- Line 1: :: Summary of file:
- Line 2: :: I. Core Data Types and Structures
- Line 3: :: +constraint-degrees, +constraint-data, +constraints:
- Line 4: ::   Define how computational constraints are structured per table—
- Line 5: ::   grouped by type (boundary, row, transition, terminal, extra)
- Line 6: ::   with associated polynomial degrees.
- Line 8: :: +preprocess-0:
- Line 9: ::   Encapsulates per-table constraint metadata, enabling reuse across proofs.
- Line 11: :: +stark-config, +stark-input:
- Line 12: ::   Define global parameters such as expansion factor and security level,
- Line 13: ::   along with computation-independent verifier input.

- Line 15: :: II. Prover Infrastructure and Polynomial Management
- Line 16: :: ++compute-codeword-commitments:
- Line 17: ::   Central routine transforming trace columns into polynomial commitments.
- Line 18: ::   Includes interpolation (compute-table-polys),
- Line 19: ::   low-degree extension (compute-lde),
- Line 20: ::   and Merkle tree commitment (bp-build-merk-heap).
- Line 22: :: compute-table-polys:
- Line 23: ::   Interpolates each table column into a low-degree polynomial over the trace domain.
- Line 25: :: compute-lde:
- Line 26: ::   Extends these polynomials to a larger evaluation domain,
- Line 27: ::   suitable for FRI-based low-degree testing and proof generation.

- Line 29: :: III. Degree Analysis and Constraint Handling
- Line 30: :: ++degree-processing:
- Line 31: ::   Computes the degree bounds of constraint polynomials for each table,
- Line 32: ::   adjusting for trace length and type (boundary, row, etc.).
- Line 34: :: +constraints-w-deg:
- Line 35: ::   Holds constraints annotated with their effective degrees,
- Line 36: ::   essential for determining valid bounds and ensuring protocol soundness.

- Line 38: :: IV. Composition Polynomial Generation
- Line 39: :: ++compute-composition-poly, ++do-compute-composition-poly:
- Line 40: ::   Construct the full composition polynomial from trace and constraint inputs.
- Line 41: ::   Applies zerofiers to enforce boundary and transition conditions,
- Line 42: ::   aggregates constraint evaluations using arithmetic over bpolys.
- Line 44: :: Constructs like bpadd, bpdiv combine scaled constraint terms efficiently,
- Line 45: ::   maintaining the degree bound needed for STARK verification.
- Line 46: :: If `is-extra` is false, skip the following computation and return `zero-bpoly`.
- Line 47: :: Otherwise, compute the contribution of the `extra` constraints to the composition polynomial.
- Line 48: :: Divide by the row zerofier polynomial to normalize domain alignment.
- Line 49: :: Call `process-composition-constraints` to evaluate each extra constraint polynomial.
- Line 50: :: Constraints are weighted using challenges (alpha, beta) extracted from `chals`.
- Line 51: :: Challenge indices begin after boundary, row, transition, and terminal constraint counts.
- Line 53: :: ++process-composition-constraints:
- Line 54: :: Processes a list of constraints paired with degree annotations and mp-ultra definitions.
- Line 55: :: For each constraint:
- Line 56: ::   - Substitutes in the trace and dynamic values into the mp expression to generate a composition polynomial.
- Line 57: ::   - Retrieves two weights: alpha and beta from the weights array.
- Line 58: ::   - Constructs a term of the form `p(x) * (α·X^{D−D_j} + β)` to lift the polynomial to uniform degree D−1.
- Line 59: ::   - Accumulates the resulting polynomial contribution into the composition polynomial using `bpadd`.

- Line 61: :: ++compute-deep:
- Line 62: :: Computes the DEEP composition polynomial used in STARK proof opening.
- Line 63: :: For each trace polynomial:
- Line 64: ::   - Converts it into field-based (fpoly) form.
- Line 65: ::   - Evaluates f(x) at two shifted points: Z and g·Z, computing `(f(x) - f(Z))/(x - Z)` and similar for gZ.
- Line 66: ::   - Forms a weighted linear combination of these evaluations using challenges and precomputed weights.
- Line 67: :: This is done twice: once using `deep-challenge` and once using `comp-eval-point`, then the two are added.
- Line 68: :: Additional composition pieces are incorporated similarly and summed with the trace contributions.

- Line 70: :: ++weighted-linear-combo:
- Line 71: :: Constructs a linear combination over rational expressions of the form `(f(x) - f(z)) / (x - z)`
- Line 72: :: where each term is scaled by a weight.
- Line 73: :: Each polynomial in the input list is offset by its corresponding opening value and normalized.
- Line 74: :: The total is accumulated using field additions and multiplications.

- Line 76: :: ++precompute-ntts:
- Line 77: :: Precomputes FFT-based NTT (Number Theoretic Transform) encodings of a set of polynomials.
- Line 78: :: Extends each polynomial to a specified length and computes its FFT over the target domain.
- Line 79: :: Returns a list of all such transformed polynomials, combined using `weld` for merging.

- Line 81: :: ++noun-get-zero-mults:
- Line 82: :: Computes how often a given noun appears in the "zero" table.
- Line 83: :: Used for determining multiplicity factors in exponent tables and external multipliers.
- Line 84: :: Operates by analyzing tree structures representing data paths (axes) in a nock formula tree.
- Line 85: :: Applies breadth-first transformations to align logical paths with computational representations.
- Line 86: :: Updates a map of subtree multiplicities using the `put-tree` arm to accumulate counts.

- Line 88: :: ++fink:
- Line 89: :: The core interpreter that traverses a nock formula in depth-first order.
- Line 90: :: Annotates each node with its axis (a breadth-first encoding of tree position).
- Line 91: :: Sorts formula nodes by axis to prepare for breadth-first evaluation in compute tables.
- Line 92: :: Builds a queue of evaluations and computes "extra data" per opcode.
- Line 93: :: Generates structures like `formula-data` and `interpret-data` to facilitate compilation.

- Line 95: :: ++interpret:
- Line 96: :: The recursive arm used by `fink` to evaluate a nock formula.
- Line 97: :: Handles each nock opcode (e.g., %0, %1, %2...) by applying the corresponding transformation.
- Line 98: :: Tags each step with its axis, captures zeroes and decode information,
- Line 99: :: and constructs a trace of intermediate computations and subformula products.
- Line 100: :: Implements ternary axis encoding to support nock’s structure (e.g., three subformulas in `%2`).
- Line 101: :: ++edit:
- Line 102: ::   Edits a noun tree at a given axis. If axis is 1, returns the new value.
- Line 103: ::   Otherwise, recursively navigates the tree based on the axis and modifies the relevant branch.
- Line 104: ::   Uses axis decoding (cap/mas) and pattern matches to update either the head (%2) or tail (%3).

- Line 106: :: ++record-all:
- Line 107: ::   Records multiple zero substitutions in a zero-map structure.
- Line 108: ::   Rolls over a list of `[subject, axis, new-subject]` triples and records each using `record`.

- Line 110: :: ++record:
- Line 111: ::   Records a single zero substitution in a nested map structure.
- Line 112: ::   If the entry does not exist, it initializes it.
- Line 113: ::   If it does exist, it increments the multiplicity count.

- Line 115: :: ++record-cons:
- Line 116: ::   Records a decode entry for a formula in a decode map.
- Line 117: ::   Uses the key `[formula head tail]` and increments count.

- Line 119: :: ++frag:
- Line 120: ::   Extracts a part of a noun at a given axis.
- Line 121: ::   Delegates to `frag-atom` if axis is atomic; otherwise, fails gracefully.

- Line 123: :: ++frag-atom:
- Line 124: ::   Atom-specific fragment logic.
- Line 125: ::   Navigates down the noun tree according to the axis.
- Line 126: ::   Recursively selects head (%2) or tail (%3) until reaching axis 1.

- Line 128: :: ++puzzle-nock:
- Line 129: ::   Constructs a proof-of-work "puzzle" from a block commitment and nonce.
- Line 130: ::   Absorbs both into a sponge function, produces random belts, generates a tree and a nock formula.
- Line 131: ::   Returns the subject and the generated formula.

- Line 133: :: ++powork:
- Line 134: ::   Produces a synthetic nock formula for a given proof-of-work length.
- Line 135: ::   Uses opcode `%6` with a combination of opcodes `%3` and `%0`.

- Line 137: :: ++gen-tree:
- Line 138: ::   Builds a binary tree from a list of atoms.
- Line 139: ::   Splits recursively to maintain a balanced shape.

- Line 141: :: ++stark-engine-jet-hook:
- Line 142: ::   Dummy hook to enable jet support in `lib/stark/prover.hoon`.
- Line 143: ::   Required for proper runtime behavior of jetted code.

- Line 145: :: ++stark-engine:
- Line 146: ::   Top-level configuration and calculator core for STARK parameters.
- Line 147: ::   Includes cryptographic constants, domain sizes, and constraint degree analysis.

- Line 149: :: ++num-challenges:
- Line 150: ::   Returns the number of challenges used, defined by `num-chals:chal`.

- Line 152: :: ++expand-factor:
- Line 153: ::   Calculates the domain expansion factor as a power of two.

- Line 155: :: ++num-spot-checks:
- Line 156: ::   Determines number of FRI verifier queries per round.

- Line 158: :: ++generator:
- Line 159: ::   Constant used as the field generator (7).

- Line 161: :: ++fri-folding-deg:
- Line 162: ::   Degree of folding per FRI round, must be a power of 2 (e.g., 8).

- Line 164: :: ++calc:
- Line 165: ::   Computes all STARK setup parameters from input table heights and constraint degree map.

- Line 167: :: ++omega:
- Line 168: ::   Computes the ordered root of unity for FRI domains.

- Line 170: :: ++fri-domain-len:
- Line 171: ::   Computes the full domain size as max padded trace length × expansion factor.

- Line 173: :: ++fri:
- Line 174: ::   Packages all FRI parameters into a single structure.

- Line 176: :: ++max-constraint-degree:
- Line 177: ::   Extracts the largest degree among all constraint types from a constraint-degrees struct.

- Line 179: :: ++max-degree / ++do-max-degree:
- Line 180: ::   Compute

- Line 189: ::    stark-core

- Line 192: ::  $zerofier-cache: cache from table height -> zerofier

- Line 194: ::  $table-to-constraint-degree: a map from table number to maximum constraint degree for that table

- Line 196: ::  mp-ultra constraint along with corresponding degrees of the constraints inside

- Line 198: ::  all constraints for one table

- Line 206: ::  constraint types


- Line 217: ::  $preprocess-0: preprocess with a version tag attached

- Line 225: ::  $stark-config: prover+verifier parameters unrelated to a particular computation
- Line 226: ::  Pin log factor and sec level to head.

- Line 231: ::TODO this type could potentially be improved



- Line 260: ::  +t-order: order terms (table names) by <=, except %jute table is always last

- Line 268: ::  +td-order: order table-dats using +t-order

- Line 274: ::  +tg-order: general ordering arm for lists with head given by table name

- Line 281: ::    jetted functions used by the stark prover


- Line 314: :: interpolate polynomials through table columns


- Line 351: ::  the @ is a degree upper bound D_j of the associated composition
- Line 352: ::  codeword, and thereby dependent on trace length, i.e.
- Line 353: ::  deg(mp constraint)*(trace-len - 1) - deg(zerofier)

- Line 362: ::  fri-deg-bound is D-1, where D is the next power of 2 greater than
- Line 363: ::  the degree bounds of all composition codewords



- Line 597: :: compute the DEEP Composition Polynomial

- Line 691: ::  +precompute-ntts



- Line 711: ::    fock-core

- Line 1077: ::  +puzzle-nock: powork puzzle





- Line 1119: ::    stark-engine

- Line 1122: ::  This is a dummy arm which is only here so lib/stark/prover.hoon can use it as its parent core.
- Line 1123: ::  Without it, jets won't work in that file.


## ztd/seven.hoon
- Line 4: ::    table-lib




- Line 19: ::  +jute-funcs: jute interface



- Line 76: ::  $table: a type that aspirationally contains all the data needed for a table utilized by the prover.

- Line 82: ::  the following $matrix type validates that the length of each row is the same. this hurts
- Line 83: ::  performance, and eventually we will move towards a more efficient memory allocation anyways,
- Line 84: ::  so it is commented out. but you can still use it for debugging by uncommenting it and commenting
- Line 85: ::  the $matrix entry above.
- Line 86: ::  +$  matrix  $|  (list row)
- Line 87: ::              |=  a=(list row)
- Line 88: ::              |-
- Line 89: ::              ?~  a  %.y
- Line 90: ::              ?~  t.a  %.y
- Line 91: ::              ?:  =(len.i.a len.i.t.a)
- Line 92: ::                $(a t.a)
- Line 93: ::              %.n
- Line 96: ::    interfaces implemented by each table

- Line 99: ::  +static-table-common: static table data shared by everything that cares about tables
- Line 100: ::    TODO either the static parts of the jute table should implement this, or
- Line 101: ::    dynamic tables need their own interface entirely








- Line 760: ::  +jlib: parts of lib/jute that arent related to particular jutes


## ztd/four.hoon
- Line 4: ::    proof-library





- Line 36: ::  number of items in proof used for pow

- Line 38: ::  extract pow from proof








- Line 132: ::  $zero-map: see description
- Line 134: ::    Nock 10 edits the noun so it has subject for the original noun and new-subject for the
- Line 135: ::    new edited noun. Nock 0 is proved exactly like a nock 10 but with new-subject=subject.
- Line 136: ::    So when recording a nock 0 you want to just pass subject in for new-subject.
- Line 137: ::    Basically a nock 0 is a special case of nock 10 where the edited tree is the original tree.

- Line 148: ::  $dyck-stack: horner accumulated stack of dyck path
- Line 149: ::  $dyck-felt: felt representing dyck-stack
- Line 150: ::  $leaf-stack: horner accumulated stack of leaves
- Line 151: ::  $leaf-felt: felt representing leaf-stack
- Line 152: ::  $ion-fprint: compressed $ion-triple: a*len + b*dyck-felt + c*leaf-felt
- Line 153: ::  $ion-triple: dyck encoding of a noun. called the ION fingerprint in the EDEN paper.
- Line 154: ::  $compute-stack: horner accumulated stack of packed-tree-felts
- Line 155: ::  $compute-felt: felt representing compute-stack
- Line 156: ::  $tree-data:
- Line 158: ::    .len: length of the leaf stack










- Line 215: ::  +ppow: field power; computes x^n






## ztd/six.hoon
- Line 4: ::    fri



## ztd/two.hoon
- Line 4: ::    math-ext: arithmetic for elements and polynomials over the extension field.

- Line 6: ::    finite field arithmetic

- Line 9: ::  +deg-to-irp:


- Line 21: ::  +lift: the unique lift of a base field element into an extension field



- Line 44: ::  +fat: is the atom a felt?

- Line 55: ::  +frip: field rip - rip a felt into a list of belts

- Line 64: ::  +frep: inverse of frip; list of belts are rep'd to a felt

- Line 74: ::  +fadd: field addition

- Line 86: ::  +fneg: field negation

- Line 95: ::  +fsub: field subtraction


- Line 122: ::  +fmul: field multiplication
- Line 124: ::  Multiply field extension elements and reduce by using the algebraic identities of the basis
- Line 125: ::  vectors.
- Line 127: ::  We are reducing mod x^3-x+1. So,
- Line 128: ::  x^3-x+1=0
- Line 129: ::  => x^3 = x-1
- Line 130: ::  => x^4 = x^2-x
- Line 132: ::  So,
- Line 133: ::  (a0+a1x+a2x^2)*(b0+b1x+b2x^2)
- Line 134: ::  = a0b0 + [a0b1+a1b0]x + [a0b2+a1b1+a2b0]x^2 + [a1b2+a2b1]x^3 + a2b2x^4
- Line 136: ::  Substituting the reductions above we get
- Line 138: ::  (a0+a1x+a2x^2)*(b0+b1x+b2x^2)
- Line 139: ::  = a0b0 + [a0b1+a1b0]x + [a0b2+a1b1+a2b0]x^2 + [a1b2+a2b1](x-1) + a2b2(x^2-x)
- Line 141: ::  = [a0b0-a1b2-a2b1] + [a0b1+a1b0+a1b2+a2b1-a2b2]x + [a0b2+a1b1+a2b0+a2b2]x^2.
- Line 143: ::  And finally we use the karatsuba trick to reduce multiplications.

- Line 175: ::  +finv: field inversion

- Line 199: ::  +mass-inversion: inverts list of elements by cleverly performing only a single inversion

- Line 236: ::  +fdiv: division of field elements

- Line 244: ::  +fpow: field power; computes x^n

- Line 264: ::  +bpeval-lift: evaluate a bpoly at a felt

- Line 282: ::    general field polynomial methods and math


- Line 288: ::  +fpadd: field polynomial addition

- Line 305: ::  +fpneg: additive inverse of a field polynomial

- Line 316: ::  fpscal: scale a polynomial by a field element

- Line 328: ::  +fpsub:  field polynomial subtraction



- Line 353: ::  f(x)=0

- Line 359: ::  f(x)=1

- Line 365: ::  f(x)=x

- Line 371: ::  +init-fpoly: transforms a list of felts into its fpoly equivalent

- Line 379: ::  +fcan: gives the canonical leading-zero-stripped representation of p(x)


- Line 397: ::  +fdegree: computes the degree of a polynomial

- Line 405: ::  +fzero-extend: make the zero coefficients for powers of x higher than deg(p) explicit



- Line 426: ::  +bpoly-to-fpoly: lift a bpoly to an fpoly

- Line 433: ::  +fpoly-from-dat
- Line 435: ::  given a dat=@ux, compute the length using met and return an fpoly

- Line 441: ::  +fp-ntt: number theoretic transform for fpolys based on anatomy of a stark

- Line 477: ::  +bp-ntt: ntt over base field

- Line 513: ::  +fp-fft: Discrete Fourier Transform (DFT) with Fast Fourier Transform (FFT) algorithm

- Line 523: ::  +fp-ifft: Inverse DFT with FFT algorithm

- Line 534: ::  +bp-fft: fft over base field

- Line 544: ::  +bp-ifft: ifft over base field

- Line 555: ::  +fpmul-naive: high school polynomial multiplication

- Line 593: ::  +fpmul-fast: polynomial multiplication with fft

- Line 614: ::  +fpmul: polynomial multiplication

- Line 628: ::  fppow: compute (p(x))^k

- Line 651: ::  +fp-hadamard
- Line 653: ::  Hadamard product of two fpolys. This is just a fancy name for pointwise multiplication.

- Line 667: ::  +fp-hadamard-pow
- Line 669: ::  Hadamard product with itself n times

- Line 681: ::  fpdvr

- Line 718: ::  +fpdiv: polynomial division
- Line 720: ::    Quasilinear algo, faster than naive. Based on the formula
- Line 721: ::    rev(p/q) = rev(q)^{-1} rev(p) mod x^{deg(p) - deg(q) + 1}.
- Line 722: ::    Why?: we can compute rev(f)^{-1} mod x^l quickly.

- Line 803: ::  fpmod: f(x) mod g(x), gives remainder r of f/g

- Line 813: ::  fpeval: evaluate a polynomial with Horner's method.

- Line 831: ::  +fpcompose: given fpolys P(X) and Q(X), compute P(Q(X))

- Line 847: ::  construct the constant fpoly f(X)=c

- Line 854: ::  +fp-decompose
- Line 856: ::  given a polynomial f(X) of degree at most D*N, decompose into D polynomials
- Line 857: ::  {h_i(X) : 0 <= i < D} each of degree at most N such that
- Line 859: ::  f(X) = h_0(X^D) + X*h_1(X^D) + X^2*h_2(X^D) + ... + X^{D-1}*h_{D-1}(X^D)
- Line 861: ::  This is just a generalization of splitting a polynomial into even and odd terms
- Line 862: ::  as the FFT does.
- Line 863: ::  h_i(X) is the terms whose degree is congruent to i modulo D.
- Line 865: ::  Passing in d=2 will split into even and odd terms.

- Line 889: ::  +fp-decomposition-eval
- Line 891: ::  given a decomposition created by +fp-decompose, evaluate it.
- Line 893: ::  input:
- Line 894: ::    n=number of pieces,
- Line 895: ::    {h_i(X): 0 <= i < n }
- Line 896: ::    c=felt (evaluation point)
- Line 898: ::  output:
- Line 899: ::  h_0(c^n) + X*h_1(c^n) + X^2*h_2(c^n) + ... + x^{n-1)}*h_{n-1}(x^n)

- Line 909: ::    specialized fpoly manipulations mostly used by the prover

- Line 911: ::  codeword: compute a Reed-Solomon codeword, i.e. evaluate a poly on a domain


- Line 944: ::  interpolate: compute the poly of minimal degree which evaluates to values on domain


- Line 1000: ::  +shift: produces the polynomial q(x) such that p(c*x) = q(x), i.e. q_i = (p_i)*(c^i)
- Line 1002: ::    Usecase:
- Line 1003: ::    If p is a polynomial you want to evaluate on coset cH of subgroup H, then you can
- Line 1004: ::    instead evaluate q on H. The value of q on h is that of p on ch: q(h) = p(ch).


- Line 1030: ::  +shift-by-unity
- Line 1032: ::  compose a polynomial in eval form over a root of unity with a power of that root of unity. It just
- Line 1033: ::  has to shift the vector to the left by pow steps and wrap back to the right.



- Line 1058: ::  +coseword: fast evaluation on a coset of a binary subgroup
- Line 1060: ::    Portmanteau of coset and codeword. If we want to evaluate a polynomial p on a coset of
- Line 1061: ::    a subgroup H, this is the same as evaluating the shifted polynomial q on H. If H is
- Line 1062: ::    generated by a binary root of unity, this evaluation is the same as an FFT.
- Line 1063: ::    NOTE: the polynomial being evaluated should have length less than the size of H.
- Line 1064: ::    This is because an FFT of a polynomial uses a root of unity of order the power of 2
- Line 1065: ::    which is larger than the length of the polynomial.
- Line 1066: ::    NOTE: 'order' is the size of H. It suffices for this single number to be our proxy for
- Line 1067: ::    H because there is a unique subgroup of this size. (Follows from the fact that F* is cyclic.)

- Line 1078: ::  +bp-coseword: coseword over base field

- Line 1089: ::  +intercosate: interpolate a polynomial taking particular values over a binary subgroup coset
- Line 1091: ::    Returns a polynomial p satisfying p(c*w^i) = v_i where w generates a cyclic subgroup of
- Line 1092: ::    binary order. This is accomplished by first obtaining q = (ifft values), which satisfies
- Line 1093: ::    q(w^i) = v_i. This is equivalent to q(c^{-1}*(c*w^i)) = v_i so comparing to our desired
- Line 1094: ::    equation we want p(x) = q(c^{-1}*x); i.e. we need to shift q by c^{-1}.






- Line 1506: ::  +mp-to-graph: multipoly arithmetic in the mp-graph representation
- Line 1508: ::    you can usually convert mpoly arithmetic into mp-graph arithmetic by
- Line 1509: ::    writing =, mp-to-graph and leaving everything else the same.



- Line 1612: ::  +mp-substitute-ultra
- Line 1614: ::  Handles substitution for %mega and %comp mp-ultra cases. If the multi-poly is a
- Line 1615: ::  single mp-mega constraint, we just call mp-substitute-mega on it. On the other hand
- Line 1616: ::  if it is a composition, we must first evaluate its dependencies, collating the
- Line 1617: ::  indexed results in a map. We then pass the map in as input when we substitute
- Line 1618: ::  the actual computation.

- Line 1646: ::  +mp-substitute-mega: Given a multipoly: sub in the chals, dyns, vars, and composition dependencies:
- Line 1648: ::  For vars, the trace polys: ~[p0(t) p1(t) ... ] are in eval form and we substitute pi(t) for xi.
- Line 1650: ::  The key insight is that multiplication is much faster on polynomials in eval form instead of
- Line 1651: ::  coefficient form. Calling bpmul will do ntt's on the arguments and an ifft on the result
- Line 1652: ::  over and over again. Instead we precompute the ntts for all the polynomials and those
- Line 1653: ::  are the arguments to substitute. Since they're already in the correct form we just compute
- Line 1654: ::  hadamard products on them, sum up all the terms, and do an ifft to get the result.
- Line 1656: ::  Another optimization is that the polynomials in eval form must be the length of the degree
- Line 1657: ::  of the final product. Since the max degree of the constraints is 4 (this method has this
- Line 1658: ::  constraint degree hardcoded for optimization purposes and must be changed by hand
- Line 1659: ::  if the constraint degree changes), the vectors must be 4*n where n is the height.

- Line 1703: :: ++  fpdiv-test
- Line 1704: ::   |=  [p=poly q=poly]
- Line 1705: ::   ^-  ?
- Line 1706: ::   =(-:(fpdvr p q) (fpdiv p q))
- Line 1707: :: ::
- Line 1708: :: ++  fpdvr-test
- Line 1709: ::   |=  [a=poly b=poly]
- Line 1710: ::   ^-  ?
- Line 1711: ::   =/  [q=poly r=poly]  (fpdvr a b)
- Line 1712: ::   ?&  =(a (fpadd (fpmul-naive b q) r))
- Line 1713: ::       (lth (degree r) (degree b))
- Line 1714: ::   ==

## ztd/one.hoon
- Line 2: ::    math-base: base field definitions and arithmetic

- Line 5: ::  $belt: base field element
- Line 7: ::    An integer in the interval [0, p).
- Line 8: ::    Due to a well chosen p, almost all numbers representable with 64 bits
- Line 9: ::    are present in the interval.
- Line 11: ::    In other words, a belt under our choice of p will always fit in 64 bits.

- Line 15: ::  $felt: extension field element
- Line 17: ::    A list of base field elements encoded as a byte array in a single atom.
- Line 18: ::    Note that a high bit is set to force allocation of the whole memory region.
- Line 20: ::    The length is assumed by field math door defined later on,
- Line 21: ::    based on degree provided to it.
- Line 23: ::    If G is a degree 3 extension field over field F, then G's elements
- Line 24: ::    are 4-tuples of the form F^4 = (F, F, F, F). E.g., if F = {0, 1},
- Line 25: ::    an element of F would be 1, while an example element of G is (0, 1, 1, 0).
- Line 27: ::    The felt type represents exactly such elements of our extension field G.
- Line 29: ::    Since the extension field over the base field "happens to be" a polynomial ring,
- Line 30: ::    the felt (1, 2, 3) can be thought of as a polynomial (1 + 2x + 3x^2).
- Line 31: ::    However, it is recommended by the elders to avoid thinking of felts
- Line 32: ::    as polynomials, and to maintain a more abstract conception of them as tuples.

- Line 36: ::  $melt: Montgomery space element
- Line 38: ::    `Montgomery space` is obtained from the base field (Z_p, +, •) by replacing ordinary
- Line 39: ::    modular multiplication • with Montgomery multiplication *: a*b = abr^{-1} mod p, where
- Line 40: ::    r = 2^64. The map a --> r•a is a field isomorphism, so in particular
- Line 41: ::    (r•a)*(r•b) = r•(a*b). Note that (r mod p) is the mult. identity in Montgomery space.

- Line 45: ::  $bpoly: a polynomial of explicit length with base field coefficients.
- Line 47: ::    A pair of a length (must fit within 32 bits) and dat, which is
- Line 48: ::    a list of base field coefficients, encoded as a byte array.
- Line 49: ::    Note that a high bit is set to force allocation of the whole memory region.
- Line 51: ::    Critically, a bpoly is isomorphic to a felt (at least when its lte is lower than degree).
- Line 53: ::    In other words, a polynomial defined as a list of base element coefficients
- Line 54: ::    is equivalent to a single element of the extension field.
- Line 56: ::    N.B: Sometimes, bpoly is used to represent a list of belt values
- Line 57: ::         of length greater than degree that are not meant to be interpreted
- Line 58: ::         as extension field elements (!).
- Line 60: ::    TODO: would be nice to have a separate typedef for the arb. len. list case

- Line 64: ::  $fpoly: a polynomial of explicit length with *extension field* coefficients.
- Line 66: ::    A pair of a length (must fit inside 32 bits) and dat, a big atom
- Line 67: ::    made up of (D * len) base field coefficients, where D is the extension degree.
- Line 68: ::    Note that a high bit is set to force allocation of the whole memory region.
- Line 70: ::    Put another way, an fpoly is a polynomial whose coefficients are felts
- Line 71: ::    (i.e. tuple of belts) instead of numbers (belts).
- Line 73: ::    N.B: Sometimes, fpoly is used to represent a list of felt values
- Line 74: ::         that aren't meant to be interpreted interpreted as polynomials
- Line 75: ::         with felt coefficients (!).

- Line 80: ::  $poly: list of coefficients [a_0 a_1 a_2 ... ] representing a_0 + a_1*x + a_2*x^2 + ...
- Line 82: ::    Note any polynomial has an infinite set of list representatives by adding 0's
- Line 83: ::    arbitrarily to the end of the list.
- Line 84: ::    Note also that ~ represents the zero polynomial.
- Line 86: ::    Somewhat surprisingly, this type can reprsent both polynomials
- Line 87: ::    whose coefficients are belts (aka felts), and polynomials whose
- Line 88: ::    coefficients are themselves felts, aka fpolys. This works because felts
- Line 89: ::    are encoded as a single atom, the same form factor as belts.

- Line 93: :::  $array
- Line 95: ::    An array of u64 words stored as an atom. This is exactly the same thing as bpoly and fpoly
- Line 96: ::    but is more general and used for any data you want to store in a contiguous array and not
- Line 97: ::    only polynomials.

- Line 101: ::  $mary
- Line 103: ::    An array where each element is step size (in u64 words). This can be used to build
- Line 104: ::    multi-dimensional arrays or to store any data you want in one contiguous array.

- Line 108: :: $mp-mega: multivariate polynomials in their final form
- Line 110: ::    The multivariate polynomial is stored in a sparse map like in the multi-poly data type.
- Line 111: ::    For each monomial term, there is a key and a value. The value is just the belt coefficient.
- Line 112: ::    The key is a bpoly which packs in each element of the monomial. It looks like this:
- Line 114: ::    [term term term ... term]=bpoly
- Line 116: ::    where each term is one 64-bit direct atom. The format of a term is this:
- Line 118: ::    3 bits - type of term
- Line 119: ::    10 bits - index of term into list of variables / challenges / dynamics
- Line 120: ::    30 bits - exponent as @ud
- Line 122: ::    [TTIIIIIIIIIIEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE]
- Line 124: ::    This only uses 43 bits which is plenty since the exponent can only be max 4 anyway.
- Line 125: ::    So it safely fits inside a direct atom.
- Line 127: ::    The type of term can be:
- Line 128: ::      con - constant (so it's just the zero bpoly and the coefficient is the value)
- Line 129: ::      var - variable. the index is the index of the variable.
- Line 130: ::      rnd - random challenge from the verifier. the index is the index into the challenge list.
- Line 131: ::      dyn - dynamic element so terminal. the index is the index into the dynamic list.
- Line 133: ::    The reason for this is that the constraints are static and so we would like to build
- Line 134: ::    them into an efficient data structure during a preprocess step and not every time we
- Line 135: ::    generate a proof. The problem is that we don't know the challenges or the dynamics until
- Line 136: ::    we are in the middle of generating a proof. So we store the index of the challenges and
- Line 137: ::    dynamics in the data structure and read them out when we evaluate or substitute the polys.

- Line 146: ::  $mp-graph: A multi-poly stored as an expression graph to preserve semantic information.







- Line 216: ::  +met-elt measure the size of the elements in a mary
- Line 218: ::  This is used to compute what the step should be when turning a list into a mary.
- Line 219: ::  If elt is larger than a belt, then (met 6 elt) will include the word for the high bit.
- Line 220: ::  We don't want this and so subtract it off. But if elt is a belt then it has no high bit.
- Line 221: ::  (met 6 elt) will return 1 and (dec (met 6 elt)) would erroneously return 0. So this is special
- Line 222: ::  cased by setting the max to be 2. This way belts return the correct size of 1.








- Line 585: ::  turn a 1-dimensional array into a 1-element 2-dimensional array

- Line 591: ::  +fpoly-to-mary
- Line 593: ::  View an fpoly as a 3-step mary.
- Line 595: ::  Note that +fpoly-to-marry just views the fpoly as an mary. It has the same length
- Line 596: ::  and each element is a felt. +lift-mop on the other hand turns the fpoly into an array
- Line 597: ::  of fpolys which has step=len.fpoly and contains exactly one element- the fpoly passed in.

- Line 604: ::  +bpoly-to-mary: view a bpoly as 1-step mary

- Line 610: ::  +i: reverse index lookup:
- Line 612: ::    given an item and a list,
- Line 613: ::    produce the index of the item in the list









- Line 684: ::  +mevy: maybe error levy

- Line 696: :: +iturn: indexed turn. Gate gets a 0-based index of which list element it is on.

- Line 706: ::  +median: computes the median value of a (list @)
- Line 708: ::    if the length of the list is odd, its the middle value. if its
- Line 709: ::    even, we average the two middle values (rounding down)

- Line 737: ::  clev: cleave a list into a list of lists w specified sizes (unless list is exhausted)
- Line 738: ::  TODO: could be made wet wrt a




- Line 773: ::  +p: field characteristic p = 2^64 - 2^32 + 1 = (2^32)*3*5*17*257*65537 + 1
- Line 774: ::  +r: radix r = 2^64
- Line 775: ::  +r-mod-p: r-mod-p = r - p
- Line 776: ::  +r2: r^2 mod p = (2^32 - 1)^2 = 2^64 - 2*2^32 + 1 = p - 2^32
- Line 777: ::  +rp: r*p
- Line 778: ::  +g: ord(g) = p - 1, i.e. g generates the (multiplicative group of the) field
- Line 779: ::  +h: ord(h) = 2^32, i.e. h = (2^32)th root of unity

- Line 788: ::  +based: in base field?

- Line 795: ::  is this noun based

- Line 804: ::  +badd: base field addition

- Line 812: ::  +bneg: base field negation

- Line 822: ::  +bsub: base field subtraction

- Line 829: ::  +bmul: base field multiplication

- Line 837: ::  +bmix: binary XOR mod p

- Line 844: ::  +mont-reduction: special algorithm; computes x•r^{-1} = (xr^{-1} mod p).
- Line 846: ::    Note this is the inverse of x --> r•x, so conceptually this is a map from
- Line 847: ::    Montgomery space to the base field.
- Line 849: ::    It's `special` bc we gain efficiency by examining the general algo by hand
- Line 850: ::    and deducing the form of the final answer, which we can code directly.
- Line 851: ::    If you compute the algo by hand you will find it convenient to write
- Line 852: ::    x = x_2*2^64 + x_1*2^32 + x_0 where x_2 is a 64-bit number less than
- Line 853: ::    p (so x < pr) and x_1, x_0 are 32-bit numbers.
- Line 854: ::    The formula comes, basically, to (x_2 - (2^32(x_0 + x_1) - x_1 - f*p));
- Line 855: ::    f is a flag bit for the overflow of 2^32(x_0 + x_1) past 64 bits.
- Line 856: ::    "Basically" means we have to add p if the formula is negative.

- Line 873: ::  +montiply: computes a*b = (abr^{-1} mod p); note mul, not fmul: avoids mod p reduction!

- Line 882: ::  +montify: transform to Montgomery space, i.e. compute x•r = xr mod p

- Line 890: ::  +bpow: fast modular exponentiation using x^n mod p = 1*(xr)*...*(xr)

- Line 908: ::  +binv: base field multiplicative inversion

- Line 941: ::  +bdiv: base field division


- Line 975: ::  +compute-size: computes the size in bits of a jammed noun

- Line 982: ::  +compute-size-noun: computes the size in bits of a noun in unrolled form in the memory arena


- Line 994: ::  +bcan: gives the canonical leading-zero-stripped representation of p(x)

- Line 1008: ::  +bdegree: computes the degree of a polynomial
- Line 1010: ::    Not just (dec (lent p)) because we need to discard possible extraneous "leading zeroes"!
- Line 1011: ::    Be very careful in using lent vs. degree!
- Line 1012: ::    NOTE: degree(~) = 0 when it should really be -∞ to preserve degree(fg) = degree(f) +
- Line 1013: ::    degree(g). So if we use the RHS of this equation to compute the LHS the cases where
- Line 1014: ::    either are the zero polynomial must be handled separately.

- Line 1022: ::  +bzero-extend: make the zero coefficients for powers of x higher than deg(p) explicit

- Line 1028: ::  +binary-zero-extend: extend with zeroes until the length is the next power of 2

- Line 1038: ::  +poly-to-map: takes list (a_i) and makes map i --> a_i

- Line 1049: ::  +map-to-poly: inverse of poly-to-map


- Line 1064: ::  +init-bpoly: given a list of belts, create a bpoly representing it






- Line 1115: ::  +bpadd: base field polynomial addition

- Line 1132: ::  +bpneg: additive inverse of a base field polynomial

- Line 1142: ::  +bpsub:  field polynomial subtraction

- Line 1149: ::  bpscal:  multiply base field scalar c by base field polynomial p

- Line 1159: ::  +bpmul: base field polynomial multiplication; naive algorithm; necessary for fmul!

- Line 1197: ::  +bp-hadamard
- Line 1199: ::  Hadamard product of two bpolys. This is just a fancy name for pointwise multiplication.

- Line 1209: ::  +bpdvr: base field polynomial division with remainder
- Line 1211: ::    Analogous to integer division: (bpdvr a b) = [q r] where a = bq + r and degree(r)
- Line 1212: ::    < degree(b). (Using the mathematical degree where degree(~) = -∞.)
- Line 1213: ::    This implies q and r are unique.
- Line 1215: ::    Algorithm is the usual one taught in high school.

- Line 1255: ::  +bpdiv: a/b for base field polynomials; q component of bpdvr

- Line 1262: ::  +bppow::  bppow: compute (p(x))^k

- Line 1286: ::  +bpmod: a mod b for base field polynomials; r component of bpdvr

- Line 1293: ::  +bpegcd: base field polynomial extended Euclidean algorithm
- Line 1295: ::    Gives gcd = d and u, v such that d = ua + vb from the Euclidean algorithm.
- Line 1296: ::    The algorithm is based on repeatedly dividing-with-remainder: a = bq + r,
- Line 1297: ::    b = rq_1 + r_1, etc. since gcd(a, b) = gcd(b, r) = ... (exercise) etc. The
- Line 1298: ::    pairs being divided in sequence are (a, b), (b, r), (r, r_1), etc. with update
- Line 1299: ::    rule new_first = old_second, new_second = remainder upon division of old_first
- Line 1300: ::    and old_second. One stops when a division by 0 would be necessary to generate
- Line 1301: ::    new_second, and then d = gcd is the second of the last full pair generated.
- Line 1302: ::    To see that u and v exist, repeatedly write d in terms of earlier and earlier
- Line 1303: ::    dividing pairs. To progressively generate the correct u, v, reexamine the original
- Line 1304: ::    calculation and write the remainders in terms of a, b at each step. Since each
- Line 1305: ::    remainder depends on the previous two, the same is true of u and v. This is the
- Line 1306: ::    reason for e.g. m1.u, which semantically is `u at time minus 1`; one can verify
- Line 1307: ::    the given initialization of these quantities.
- Line 1308: ::    NOTE: mathematically, gcd is not unique (only up to a scalar).

- Line 1329: ::  +bpeval: evaluate a bpoly at a belt

- Line 1347: ::  construct the constant bpoly f(X)=c

- Line 1354: ::  +bp-decompose
- Line 1356: ::  given a polynomial f(X) of degree at most D*N, decompose into D polynomials
- Line 1357: ::  {h_i(X) : 0 <= i < D} each of degree at most N such that
- Line 1359: ::  f(X) = h_0(X^D) + X*h_1(X^D) + X^2*h_2(X^D) + ... + X^{D-1}*h_{D-1}(X^D)
- Line 1361: ::  This is just a generalization of splitting a polynomial into even and odd terms
- Line 1362: ::  as the FFT does.
- Line 1363: ::  h_i(X) is the terms whose degree is congruent to i modulo D.
- Line 1365: ::  Passing in d=2 will split into even and odd terms.

## ztd/three.hoon
- Line 4: ::    misc-lib

- Line 6: ::  +flec: reflect a noun, i.e. switch head and tail





- Line 1271: ::  TODO: needs to be audited and thoroughly tested


## zose.hoon
- Line 1: ::  /common/zose: vendored types from zuse
- Line 2: ::  #  %zose
- Line 4: ::    This library contains cryptographic primitives and utilities
- Line 5: ::    vendored from zuse.hoon. It includes various cryptosuites,
- Line 6: ::    number theory operations, and specific implementations like
- Line 7: ::    AES and elliptic curve cryptography. Also includes translation
- Line 8: ::    utilities for working with various formats.







- Line 3428: ::  $puth: $pith without faces

- Line 3431: ::  +pith: pith utilities

- Line 3474: ::  $pave: better path to pith

- Line 3482: ::  $stip:  better typed path parser


## test.hoon
- Line 1: ::  testing utilities meant to be directly used from files in %/tests

- Line 4: ::  +expect-eq: compares :expected and :actual and pretty-prints the result

- Line 28: ::  +expect: compares :actual to %.y and pretty-prints anything else

- Line 33: ::  +expect-fail: kicks a trap, expecting crash. pretty-prints if succeeds

- Line 57: ::  +expect-runs: kicks a trap, expecting success; returns trace on failure

- Line 67: ::  $a-test-chain: a sequence of tests to be run
- Line 69: ::  NB: arms shouldn't start with `test-` so that `-test % ~` runs

- Line 77: ::  +run-chain: run a sequence of tests, stopping at first failure

- Line 89: ::  +category: prepends a name to an error result; passes successes unchanged

- Line 97: ::  +give-result: runs a test, pretty-prints the result

- Line 120: ::  Convenience functions for roswell testing modules




- Line 157: ::  +get-prefix-arms: produce arms that begin with .prefix


## nock-prover.hoon



## tx-engine.hoon
- Line 5: ::    tx-engine: this contains all transaction types and logic related to dumbnet.
- Line 7: ::  the most notable thing about how this library is written are the types. we use
- Line 8: ::  a namespacing scheme for functions that are primarily about particular types inside
- Line 9: ::  of the namespace for that type, as suggested by Ted in urbit/#6881. that is:
- Line 11: ::  ++  list
- Line 12: ::    =<  form
- Line 13: ::    |%
- Line 14: ::    ++  form  |$  [a]  $?(~ [i=a t=$])
- Line 15: ::    ++  flop  |*(...)
- Line 16: ::    ++  turn  |*(...)
- Line 17: ::    ...
- Line 18: ::    --
- Line 20: ::  we refer to these types as 'B-types'

- Line 27: ::  size in bits. this is not a blockchain constant, its just an alias
- Line 28: ::  to make it clear what the atom represents and theres not a better spot
- Line 29: ::  for it.

- Line 32: ::   $blockchain-constants
- Line 34: ::  type to hold all the blockchain constants. provided for convenience
- Line 35: ::  when using non-default constants.

- Line 82: ::    tx-engine
- Line 84: ::  contains the tx engine. the default sample for the door is mainnet constants,
- Line 85: ::  pass something else in if you need them (and make sure to use the same door
- Line 86: ::  for all calls into this library).

- Line 90: ::  one quarter epoch duration - used in target adjustment calculation

- Line 92: ::  4x epoch duration - used in target adjustment calculation



- Line 131: ::  $hash: output of tip:zoon arm



- Line 229: ::  $signature: multisigs, with a single sig as a degenerate case

- Line 254: ::  $source: commitment to sources of an note
- Line 256: ::    for an ordinary note, this is a commitment to the notes that spend into a
- Line 257: ::    given note. for a coinbase, this is the hash of the previous block (this avoids
- Line 258: ::    a hash loop in airwalk)
- Line 260: ::    so you should be able to walk backwards through the sources of any transaction,
- Line 261: ::    and the notes that spent into that, and the notes that spent into those, etc,
- Line 262: ::    until you reach coinbase(s) at the end of that walk.

- Line 284: ::  $nname: unique note identifier
- Line 286: ::    first hash is a commitment to the note's .lock and whether or
- Line 287: ::    not it has a timelock.
- Line 289: ::    second hash is a commitment to the note's source and actual
- Line 290: ::    timelock
- Line 292: ::    there are also stubs for pacts, which are currently unimplemented.
- Line 293: ::    but they are programs that must return %& in order for the note
- Line 294: ::    to be spendable, and are included in the name of the note. right
- Line 295: ::    now, pacts are ~ and always return %&.
- Line 297: ::TODO for dumbnet, this will be [hash hash ~] but eventually we want (list hash)
- Line 298: ::which should be thought of as something like a top level domain, subdomain, etc.

- Line 363: ::  $page: a block
- Line 365: ::    .digest: block hash, hash of +.page
- Line 366: ::    .pow: stark seeded by hash of +>.page
- Line 367: ::    .parent: .digest of parent block
- Line 368: ::    .tx-ids: ids of txs included in block
- Line 369: ::    .coinbase: $coinbase-split
- Line 370: ::    .timestamp:
- Line 371: ::      time from (arbitrary time) in seconds. not exact.
- Line 372: ::      practically, it will never exceed the goldilocks prime.
- Line 373: ::    .epoch-counter: how many blocks in current epoch (0 to 2015)
- Line 374: ::    .target: target for current epoch
- Line 375: ::    .accumulated-work: sum of work over the chain up to this point
- Line 376: ::    .height: page number of block
- Line 377: ::    .msg: optional message as a (list belt)
- Line 379: ::    if you're wondering where the nonce is, its in the %puzzle
- Line 380: ::    of a $proof.
- Line 382: ::    fields for the commitment are ordered from most frequently updated
- Line 383: ::    to least frequently updated for merkleizing efficiency - except for
- Line 384: ::    .parent, in order to allow for PoW-chain proofs to be as small as
- Line 385: ::    possible.

- Line 592: ::  A locally-stored page. The only difference from +page is that pow is jammed
- Line 593: ::  to save space. Must be converted into a +page (ie cue the pow) for hashing.

- Line 618: ::  +page-msg: (list belt) that enforces that each elt is a belt

- Line 636: ::  +genesis-seal: information to identify the correct genesis block
- Line 638: ::    before nockchain is launched, a bitcoin block height and message
- Line 639: ::    hash will be publicly released. the height is the height at which
- Line 640: ::    nockchain will be launched. the "correct" genesis block will
- Line 641: ::    be identified by matching the message hash with the hash of the
- Line 642: ::    message in the genesis block, and then confirming that the parent
- Line 643: ::    of the genesis block is a hash built from the message, the height,
- Line 644: ::    and the hash of the bitcoin block at that height.
- Line 646: ::    the height and message hash are known as the "genesis seal".

- Line 663: ::  $genesis-template:
- Line 665: ::    supplies the block hash and height of the Bitcoin block which must be
- Line 666: ::    used for the genesis block. note that the hash is a SHA256, while we
- Line 667: ::    want a 5-tuple $noun-digest. we call +new in this core with the raw
- Line 668: ::    atom representing the SHA256 hash, which then converts it into a 5-tuple.



- Line 874: ::  +raw-tx: a tx as found in the mempool, i.e. the wire format of a tx.
- Line 876: ::    in order for a raw-tx to grow up to become a tx, it needs to be included in
- Line 877: ::    a block. some of the data of a tx cannot be known until we know which block
- Line 878: ::    it is in. a raw-tx is all the data we can know about a transaction without
- Line 879: ::    knowing which block it is in. when a miner reads a raw-tx from the mempool,
- Line 880: ::    it should first run validate:raw-tx on it to check that the inputs are signed.
- Line 881: ::    then the miner can begin deciding how
- Line 882: ::TODO we might want an unsigned version of this as well

- Line 997: ::  $tx: once a raw-tx is being included in a block, it becomes a tx

- Line 1038: ::  $timelock-intent: enforces $timelocks in output notes from $seeds
- Line 1040: ::    the difference between $timelock and $timelock-intent is that $timelock-intent
- Line 1041: ::    permits the values ~ and [~ ~ ~] while $timelock does not permit [~ ~ ~].
- Line 1042: ::    the reason for this is that a non-null timelock intent forces the output
- Line 1043: ::    note to have this timelock. so a ~ means it does not enforce any timelock
- Line 1044: ::    restriction on the output note, while [~ ~ ~] means that the output note
- Line 1045: ::    must have a timelock of ~.

- Line 1080: ::  $timelock: an absolute and relative range of page numbers this note may be spent

- Line 1115: ::  $timelock-range: unit range of pages
- Line 1117: ::    the union of all valid ranges in which all inputs of a tx may spend
- Line 1118: ::    given their timelocks. for the dumbnet, we only permit at most one utxo
- Line 1119: ::    with a non-null timelock-range per transaction.

- Line 1187: ::  $lock: m-of-n signatures needed to spend a note
- Line 1189: ::    m (the number of sigs needed) and n (the number of possible signers)
- Line 1190: ::    must both fit in an 8-bit number, and not be 0. so 1 <= n,m <= 255. While
- Line 1191: ::    a lock may only be "unlocked" if m =<n, we do permit constructing m>n
- Line 1192: ::    with an issued warning, since this may happen when constructing a
- Line 1193: ::    transaction piece-by-piece.
- Line 1195: ::    TODO: disambiguate intermediate locks and final locks for validation.

- Line 1399: ::  $nnote: Nockchain note. A UTXO.

- Line 1449: ::  $coinbase: mining reward. special kind of note


- Line 1534: ::  $coinbase-split: total number of nicks split between mining pubkeys
- Line 1536: ::    despite also being a (z-map lock @), this is not the same thing as .shares
- Line 1537: ::    from the mining state. this is the actual number of coins split between the
- Line 1538: ::    locks, while .shares is a proportional split used to calculate the actual
- Line 1539: ::    number.

- Line 1642: ::  $seed: carrier of a quantity of assets from an $input to an $output


- Line 1805: ::  $spend: a signed collection of seeds used in an $input
- Line 1807: ::    .signature: expected to be on the hash of the spend's seeds
- Line 1809: ::    .seeds: the individual transfers to individual output notes
- Line 1810: ::    that the spender is authorizing

- Line 1964: ::  $input: note transfering assets to outputs within a tx
- Line 1966: ::    .note: the note that is transferring assets to outputs within the tx.
- Line 1967: ::    the note must exist in the balance in order for it to spend, and it must
- Line 1968: ::    be removed from the balance atomically as it spends.
- Line 1970: ::    .spend: authorized commitment to the recipient notes that the input is
- Line 1971: ::    transferring assets to and amount of assets given to each output.

- Line 2074: ::  $output: recipient of assets transferred by some inputs in a tx
- Line 2076: ::    .note: the recipient of assets transferred by some inputs in a tx,
- Line 2077: ::    and is added to the balance atomically with it receiving assets.
- Line 2079: ::    .seeds: the "carrier" for the individual asset gifts it receives from
- Line 2080: ::    each input that chose to spend into it.

- Line 2114: ::  $tx-acc: accumulator for updating balance while processing txs
- Line 2116: ::    ephemeral struct for incrementally updating balance per tx in a page,
- Line 2117: ::    and for accumulating fees and size per tx processed, to be checked
- Line 2118: ::    against the coinbase assets and max-page-size

## zeke.hoon

## markdown/markdown.hoon

- Line 166: ::  Parse to and from Markdown text format

## markdown/types.hoon

## schedule.hoon



## wrapper.hoon
- Line 2: :: Structure arms.

- Line 8: :: keep has a wet gate.

- Line 102: :: End of Second Expression

## nock-common.hoon
- Line 1: :: nock-common: common arms between nock-prover and nock-verifier

- Line 6: ::  all values in this table must generally be in the order of the tables
- Line 7: ::  specified in the following arm.

- Line 16: ::  +core-table-names: tables utilized for every proof

- Line 24: ::  +opt-static-table-names: static tables only used when jute-flag=%.y
- Line 26: ::    TODO make these tables optional depending on whether these jutes are
- Line 27: ::    actually used

- Line 32: ::  +opt-dynamic-table-names: dynamic tables only used when jute-flag=%.y




- Line 55: ::  Widths of static tables. Dynamic tables (ie jute) need to be computed separately and passed
- Line 56: ::  in specific data needed for each table.














## table/verifier/compute.hoon




- Line 72: ::  Set ions n=m

- Line 92: ::  set ion to be 0


## table/verifier/memory.hoon

## table/compute.hoon

## table/prover/compute.hoon





















- Line 313: ::  pinv but 1/0 = 0










## table/prover/memory.hoon








- Line 169: ::  gen-nock
- Line 171: ::     generates nock=[s f], parametrized by n, which evaluates to prod
- Line 172: ::     s.t. the Nock reduction rules only use Nock 2 and Nock 0's into
- Line 173: ::     the subject s







- Line 229: ::  bft: breadth-first traversal

- Line 246: ::  na-bft: non-atomic breadth-first traversal
- Line 248: ::    i.e. only internal nodes are counted, not atoms.

- Line 274: ::  bfta: breadth-first traversal w/ axis labelling



- Line 301: ::  rna-bfta: reversed non-atomic breadth-first traversal w axes
- Line 303: ::    Returns the breadth-first traversal in reverse order bc the output is
- Line 304: ::    piped to add-ions, which is most efficient if constructed from the bottom
- Line 305: ::    of the tree to the top.

- Line 332: ::  add-ions: adds ions to the output of rna-bfta


- Line 368: ::  +cons-ion: cons of 2 ion triples of nouns.




## table/memory.hoon

## zoon.hoon
- Line 1: ::  /lib/zoon: vendored types from hoon.hoon










- Line 587: ::  +dor-tip: depth order.
- Line 589: ::    Orders z-in ascending tree depth.

- Line 602: ::  +gor-tip: tip order.
- Line 604: ::    Orders z-in ascending +tip hash order, collisions fall back to +dor.

- Line 613: ::  +mor-tip: mor tip order.
- Line 615: ::    Orders z-in ascending double +tip hash order, collisions fall back to +dor.





## nock-verifier.hoon



## bip39.hoon
- Line 1: ::  bip39 implementation in hoon


- Line 41: ::NOTE  always produces a 512-bit result

