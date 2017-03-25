--[[
< CATHERINE > - A free role-playing framework for Garry's Mod.
Development and design by L7D.

Catherine is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Catherine.  If not, see <http://www.gnu.org/licenses/>.
]]--
local PLUGIN = PLUGIN

local ITEM = catherine.item.New( "boyhood_1", "BOOK" )
ITEM.name = "^Item_Name_Boyhood1"
ITEM.desc = "^Item_Desc_Boyhood1"
ITEM.model = "models/props_lab/bindergreenlabel.mdl"
ITEM.cost = 200
ITEM.weight = 0.3
ITEM.html = function( )
return [[
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
    <title></title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
	<style>
		@import url(http://fonts.googleapis.com/css?family=Open+Sans);
		body {
			font-family: "Open Sans", "나눔고딕", "NanumGothic", "맑은 고딕", "Malgun Gothic", "serif", "sans-serif"; 
			-webkit-font-smoothing: antialiased;
		}
	</style>
</head>
<body>
	<div class="container" style="margin-top:0;">
	<div class="page-header">
		<h4>]] .. catherine.util.StuffLanguage( ITEM.name ) .. [[&nbsp&nbsp<small>]] .. catherine.util.StuffLanguage( ITEM.desc ) .. [[</small></h4>
	</div>
	
	Again two carriages stood at the front door of the house at Petrovskoe. In one of them sat Mimi, the two girls, and their maid, with the bailiff, Jakoff, on the box, while in the other--a britchka--sat Woloda, myself, and our servant Vassili. Papa, who was to follow us to Moscow in a few days, was standing bareheaded on the entrance-steps. He made the sign of the cross at the windows of the carriages, and said:
	
	"Christ go with you! Good-bye."

	Jakoff and our coachman (for we had our own horses) lifted their caps in answer, and also made the sign of the cross.

	"Amen. God go with us!"

	The carriages began to roll away, and the birch-trees of the great avenue filed out of sight.

	I was not in the least depressed on this occasion, for my mind was not so much turned upon what I had left as upon what was awaiting me. In proportion as the various objects connected with the sad recollections which had recently filled my imagination receded behind me, those recollections lost their power, and gave place to a consolatory feeling of life, youthful vigour, freshness, and hope.

	Seldom have I spent four days more--well, I will not say gaily, since I should still have shrunk from appearing gay--but more agreeably and pleasantly than those occupied by our journey.

	No longer were my eyes confronted with the closed door of Mamma's room (which I had never been able to pass without a pang), nor with the covered piano (which nobody opened now, and at which I could never look without trembling), nor with mourning dresses (we had each of us on our ordinary travelling clothes), nor with all those other objects which recalled to me so vividly our irreparable loss, and forced me to abstain from any manifestation of merriment lest I should unwittingly offend against her memory.

	On the contrary, a continual succession of new and exciting objects and places now caught and held my attention, and the charms of spring awakened in my soul a soothing sense of satisfaction with the present and of blissful hope for the future.

	Very early next morning the merciless Vassili (who had only just entered our service, and was therefore, like most people in such a position, zealous to a fault) came and stripped off my counterpane, affirming that it was time for me to get up, since everything was in readiness for us to continue our journey. Though I felt inclined to stretch myself and rebel--though I would gladly have spent another quarter of an hour in sweet enjoyment of my morning slumber--Vassili's inexorable face showed that he would grant me no respite, but that he was ready to tear away the counterpane twenty times more if necessary. Accordingly I submitted myself to the inevitable and ran down into the courtyard to wash myself at the fountain.


	In the coffee-room, a tea-kettle was already surmounting the fire which Milka the ostler, as red in the face as a crab, was blowing with a pair of bellows. All was grey and misty in the courtyard, like steam from a smoking dunghill, but in the eastern sky the sun was diffusing a clear, cheerful radiance, and making the straw roofs of the sheds around the courtyard sparkle with the night dew. Beneath them stood our horses, tied to mangers, and I could hear the ceaseless sound of their chewing. A curly-haired dog which had been spending the night on a dry dunghill now rose in lazy fashion and, wagging its tail, walked slowly across the courtyard.

	The bustling landlady opened the creaking gates, turned her meditative cows into the street (whence came the lowing and bellowing of other cattle), and exchanged a word or two with a sleepy neighbour. Philip, with his shirt-sleeves rolled up, was working the windlass of a draw-well, and sending sparkling fresh water coursing into an oaken trough, while in the pool beneath it some early-rising ducks were taking a bath. It gave me pleasure to watch his strongly-marked, bearded face, and the veins and muscles as they stood out upon his great powerful hands whenever he made an extra effort. In the room behind the partition-wall where Mimi and the girls had slept (yet so near to ourselves that we had exchanged confidences overnight) movements now became audible, their maid kept passing in and out with clothes, and, at last the door opened and we were summoned to breakfast. Woloda, however, remained in a state of bustle throughout as he ran to fetch first one article and then another and urged the maid to hasten her preparations.

	The horses were put to, and showed their impatience by tinkling their bells. Parcels, trunks, dressing-cases, and boxes were replaced, and we set about taking our seats. Yet, every time that we got in, the mountain of luggage in the britchka seemed to have grown larger than before, and we had much ado to understand how things had been arranged yesterday, and how we should sit now. A tea-chest, in particular, greatly inconvenienced me, but Vassili declared that "things will soon right themselves," and I had no choice but to believe him.

	The sun was just rising, covered with dense white clouds, and every object around us was standing out in a cheerful, calm sort of radiance. The whole was beautiful to look at, and I felt comfortable and light of heart.

	Before us the road ran like a broad, sinuous ribbon through cornfields glittering with dew. Here and there a dark bush or young birch-tree cast a long shadow over the ruts and scattered grass-tufts of the track. Yet even the monotonous din of our carriage-wheels and collar-bells could not drown the joyous song of soaring larks, nor the combined odour of moth-eaten cloth, dust, and sourness peculiar to our britchka overpower the fresh scents of the morning. I felt in my heart that delightful impulse to be up and doing which is a sign of sincere enjoyment.

	As I had not been able to say my prayers in the courtyard of the inn, but had nevertheless been assured once that on the very first day when I omitted to perform that ceremony some misfortune would overtake me, I now hastened to rectify the omission. Taking off my cap, and stooping down in a corner of the britchka, I duly recited my orisons, and unobtrusively signed the sign of the cross beneath my coat. Yet all the while a thousand different objects were distracting my attention, and more than once I inadvertently repeated a prayer twice over.

	Soon on the little footpath beside the road became visible some slowly moving figures. They were pilgrims. On their heads they had dirty handkerchiefs, on their backs wallets of birch-bark, and on their feet bundles of soiled rags and heavy bast shoes. Moving their staffs in regular rhythm, and scarcely throwing us a glance, they pressed onwards with heavy tread and in single file.

	"Where have they come from?" I wondered to myself, "and whither are they bound? Is it a long pilgrimage they are making?" But soon the shadows they cast on the road became indistinguishable from the shadows of the bushes which they passed.

	Next a carriage-and-four could be seen approaching us. In two seconds the faces which looked out at us from it with smiling curiosity had vanished. How strange it seemed that those faces should have nothing in common with me, and that in all probability they would never meet my eyes again!

	Next came a pair of post-horses, with the traces looped up to their collars. On one of them a young postillion-his lamb's wool cap cocked to one side-was negligently kicking his booted legs against the flanks of his steed as he sang a melancholy ditty. Yet his face and attitude seemed to me to express such perfect carelessness and indolent ease that I imagined it to be the height of happiness to be a postillion and to sing melancholy songs.

	Far off, through a cutting in the road, there soon stood out against the light-blue sky, the green roof of a village church. Presently the village itself became visible, together with the roof of the manor-house and the garden attached to it. Who lived in that house? Children, parents, teachers? Why should we not call there and make the acquaintance of its inmates?

	Next we overtook a file of loaded waggons--a procession to which our vehicles had to yield the road.

	"What have you got in there?" asked Vassili of one waggoner who was dangling his legs lazily over the splashboard of his conveyance and flicking his whip about as he gazed at us with a stolid, vacant look; but he only made answer when we were too far off to catch what he said.

	"And what have you got?" asked Vassili of a second waggoner who was lying at full length under a new rug on the driving-seat of his vehicle. The red poll and red face beneath it lifted themselves up for a second from the folds of the rug, measured our britchka with a cold, contemptuous look, and lay down again; whereupon I concluded that the driver was wondering to himself who we were, whence we had come, and whither we were going.

	These various objects of interest had absorbed so much of my time that, as yet, I had paid no attention to the crooked figures on the verst posts as we passed them in rapid succession; but in time the sun began to burn my head and back, the road to become increasingly dusty, the impedimenta in the carriage to grow more and more uncomfortable, and myself to feel more and more cramped. Consequently, I relapsed into devoting my whole faculties to the distance-posts and their numerals, and to solving difficult mathematical problems for reckoning the time when we should arrive at the next posting-house.

	"Twelve versts are a third of thirty-six, and in all there are forty-one to Lipetz. We have done a third and how much, then?", and so forth, and so forth.

	"Vassili," was my next remark, on observing that he was beginning to nod on the box-seat, "suppose we change seats? Will you?" Vassili agreed, and had no sooner stretched himself out in the body of the vehicle than he began to snore. To me on my new perch, however, a most interesting spectacle now became visible-- namely, our horses, all of which were familiar to me down to the smallest detail.

	"Why is Diashak on the right today, Philip, not on the left?" I asked knowingly. "And Nerusinka is not doing her proper share of the pulling."

	"One could not put Diashak on the left," replied Philip, altogether ignoring my last remark. "He is not the kind of horse to put there at all. A horse like the one on the left now is the right kind of one for the job."

	After this fragment of eloquence, Philip turned towards Diashak and began to do his best to worry the poor animal by jogging at the reins, in spite of the fact that Diashak was doing well and dragging the vehicle almost unaided. This Philip continued to do until he found it convenient to breathe and rest himself awhile and to settle his cap askew, though it had looked well enough before.

	I profited by the opportunity to ask him to let me have the reins to hold, until, the whole six in my hand, as well as the whip, I had attained complete happiness. Several times I asked whether I was doing things right, but, as usual, Philip was never satisfied, and soon destroyed my felicity.

	The heat increased until a hand showed itself at the carriage window, and waved a bottle and a parcel of eatables; whereupon Vassili leapt briskly from the britchka, and ran forward to get us something to eat and drink.

	When we arrived at a steep descent, we all got out and ran down it to a little bridge, while Vassili and Jakoff followed, supporting the carriage on either side, as though to hold it up in the event of its threatening to upset.

	After that, Mimi gave permission for a change of seats, and sometimes Woloda or myself would ride in the carriage, and Lubotshka or Katenka in the britchka. This arrangement greatly pleased the girls, since much more fun went on in the britchka. Just when the day was at its hottest, we got out at a wood, and, breaking off a quantity of branches, transformed our vehicle into a bower. This travelling arbour then bustled on to catch the carriage up, and had the effect of exciting Lubotshka to one of those piercing shrieks of delight which she was in the habit of occasionally emitting.

	At last we drew near the village where we were to halt and dine. Already we could perceive the smell of the place--the smell of smoke and tar and sheep-and distinguish the sound of voices, footsteps, and carts. The bells on our horses began to ring less clearly than they had done in the open country, and on both sides the road became lined with huts--dwellings with straw roofs, carved porches, and small red or green painted shutters to the windows, through which, here and there, was a woman's face looking inquisitively out. Peasant children clad in smocks only stood staring open-eyed or, stretching out their arms to us, ran barefooted through the dust to climb on to the luggage behind, despite Philip's menacing gestures. Likewise, red-haired waiters came darting around the carriages to invite us, with words and signs, to select their several hostelries as our halting-place.

	Presently a gate creaked, and we entered a courtyard. Four hours of rest and liberty now awaited us.
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
	</body>
</html>
]]
end

catherine.item.Register( ITEM )