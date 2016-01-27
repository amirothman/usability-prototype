$(window).load(function(){
        


        $("[data-toggle]").click(function() {

          var toggle_el = $(this).data("toggle");
          $(toggle_el).toggleClass("open-sidebar");
        });

         $(".swipe-area").swipe({
              swipeStatus:function(event, phase, direction, distance, duration, fingers)
                  {
                      if (phase=="move" && direction =="right") {
                           $(".container").addClass("open-sidebar");
                           return false;
                      }
                      if (phase=="move" && direction =="left") {
                           $(".container").removeClass("open-sidebar");
                           return false;
                      }
                  }
          });


         $('#mark_all').change(function() {
            if($(this).is(":checked")) {
              $('.marked').prop("checked",true);
            }
          });

         $('#mark_all').change(function() {
            if(!$(this).is(":checked")) {
              $('.marked').prop("checked",false);
            }
          });

         $('.marked').change(function(){
            if($(this).is(":checked")){
              $("#read-delete").css("visibility","visible")
            }
         });

         $('.marked').change(function(){
            if(!$(this).is(":checked")){
              $("#read-delete").css("visibility","hidden")
            }
         });


         $(".unread").click(function(){
            var class_name = $(this).attr("class");
            class_name = class_name.split(" ");
            class_name = class_name[1];
            $(".unread-mail."+class_name).toggleClass("read-mail "+class_name);
         });

      
});

        $(document).ready(function() {
            $('#contacts').DataTable(
              );
        } );